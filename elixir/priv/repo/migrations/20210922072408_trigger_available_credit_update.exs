defmodule Homework.Repo.Migrations.TriggerAvailableCreditUpdate do
  use Ecto.Migration

  # This will be extremely inefficient as the "transactions" table grows...
  # Unfortuntately, due to my lack of understanding of Ecto/Elixir, I could not find a way to make this work in a more optimal way.
  # I spent a good amout of time trying to get a `virtual` field working which I believe to be a more correct solution since it will be calculated
  # when querying the companies table instead of this approach that must calculate it every time a transaction is created/updated which will most likely be very frequent
  # or at least more frequent then querying company information I think.

  def up do
    execute("""
        CREATE OR REPLACE FUNCTION calculate_available_credit()
    RETURNS trigger AS $calculate_available_credit$
    BEGIN
        UPDATE companies
            SET available_credit = credit_line - (SELECT SUM(amount)
                             FROM transactions
                             WHERE transactions.company_id = companies.id);

        RETURN NEW;
    END;
    $calculate_available_credit$
    LANGUAGE 'plpgsql';
    """)

    execute("""
    CREATE TRIGGER update_available_credit_on_change
    AFTER INSERT OR UPDATE
    ON transactions
    FOR EACH ROW
    EXECUTE PROCEDURE calculate_available_credit();
    """)
  end

  def down do
    execute("""
      DROP TRIGGER IF EXISTS update_available_credit_on_change ON transactions;
    """)
  end
end

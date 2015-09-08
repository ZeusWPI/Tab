class TransactionDatatable < AjaxDatatablesRails::Base

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= []
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= []
  end

  private

  def data
    records.map do |record|
      [
        record.id, record.debtor.name, record.creditor.name, record.amount
      ]
    end
  end

  def get_raw_records
    Transaction.all.eager_load(:debtor, :creditor)
  end
end

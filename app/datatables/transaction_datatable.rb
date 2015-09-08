class TransactionDatatable < AjaxDatatablesRails::Base

  def sortable_columns
    @sortable_columns ||= ['Transaction.id']
  end

  def searchable_columns
    @searchable_columns ||= []
  end

  private

  def data
    records.map do |record|
      [ record.id, record.debtor.name, record.creditor.name, record.amount ]
    end
  end

  def get_raw_records
    Transaction.all.eager_load(:debtor, :creditor)
  end
end

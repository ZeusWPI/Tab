class TransactionDatatable < AjaxDatatablesRails::Base
  include TransactionsHelper

  def sortable_columns
    @sortable_columns ||= ['Transaction.amount']
  end

  def searchable_columns
    @searchable_columns ||= []
  end

  private
  def data
    records.map do |record|
      [ amount_in_perspective(record, options[:user]),
        record.origin,
        record.message,
        get_transaction_peer(record, options[:user]).name,
        record.created_at.strftime('%d/%m/%y %H:%M')
      ]
    end
  end

  def get_raw_records
    options[:user].transactions.eager_load(:debtor, :creditor)
  end
end

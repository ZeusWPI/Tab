module TransactionsHelper
  def amount a
    a.zero? ? nil : number_with_precision(a/100.0, precision: 2)
  end
end

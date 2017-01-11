class PagesController < ApplicationController
  require 'statistics'

  def landing
    query = TransactionsQuery.new(current_user)
    @transactions = ActiveRecord::Base.connection.exec_query(query.query.order(query.arel_table[:time].desc).take(10).project(Arel.star).to_sql)
  end

  def sign_in
    @statistics = Statistics.new
  end
end

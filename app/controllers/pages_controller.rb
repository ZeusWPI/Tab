# frozen_string_literal: true

class PagesController < ApplicationController
  def landing
    query = TransactionsQuery.new(current_user)
    @transactions = ActiveRecord::Base.connection.exec_query(query.query.order(query.arel_table[:time].desc).take(10).project(Arel.star).to_sql)
    @requests = current_user.incoming_requests.open.includes(:creditor).take(10)
    @total_incoming_amount = current_user.incoming_requests.open.sum(:amount)
    @outgoing_requests = current_user.outgoing_requests.open.includes(:debtor).take(10)
    @total_outgoing_amount = current_user.outgoing_requests.open.sum(:amount)
    @notifications = current_user.notifications.unread
  end

  def sign_in_page; end
end

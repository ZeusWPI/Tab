# frozen_string_literal: true

class TransactionsQuery
	attr_reader :arel_table

	def initialize(user)
		@user = user
		@transactions = Arel::Table.new(:transactions)
		@perspectived = Arel::Table.new(:perspectived_transactions)
		@peers = Arel::Table.new(:users).alias("peers")
		@arel_table = Arel::Table.new("#{@user.name}_transactions")
	end

	def query
		Arel::SelectManager.new(ActiveRecord::Base).from(arel)
	end

	def arel
		Arel::Nodes::TableAlias.new(
			issued_by(User).union(:all, issued_by(Client)),
			arel_table.name
		)
	end

	def issued_by(klass)
		issuers = klass.arel_table.alias("issuer")
		Arel::SelectManager
			.new(ActiveRecord::Base)
			.from(transactions)
			.join(@peers).on(@peers[:id].eq(@perspectived[:peer_id]))
			.join(issuers).on(issuers[:id].eq(@perspectived[:issuer_id]))
			.where(@perspectived[:issuer_type].eq(klass.name))
			.project(
				@perspectived[:amount],
				@perspectived[:time],
				@perspectived[:message],
				@peers[:name].as("peer"),
				issuers[:name].as("issuer")
			)
	end

	def transactions
		Arel::Nodes::TableAlias.new(
			incoming.union(:all, outgoing),
			@perspectived.name
		)
	end

	def outgoing
		@transactions
			.where(@transactions[:debtor_id].eq(@user.id))
			.project(
				(@transactions[:amount] * Arel::Nodes::SqlLiteral.new("-1")).as("amount"),
				@transactions[:creditor_id].as("peer_id"),
				@transactions[:created_at].as("time"),
				@transactions[:issuer_id],
				@transactions[:issuer_type],
				@transactions[:message]
			)
	end

	def incoming
		@user.incoming_transactions.arel
		@transactions
			.where(@transactions[:creditor_id].eq(@user.id))
			.project(
				@transactions[:amount],
				@transactions[:debtor_id].as("peer_id"),
				@transactions[:created_at].as("time"),
				@transactions[:issuer_id],
				@transactions[:issuer_type],
				@transactions[:message]
			)
	end
end

# frozen_string_literal: true

json.array! @requests do |r|
  json.id r.id
  json.debtor r.debtor.name
  json.creditor r.creditor.name
  json.time r.updated_at
  json.amount r.amount
  json.message r.message
  json.issuer r.issuer.name
  json.actions do
    permissions = []
    permissions << :confirm if can?(:confirm, r)
    permissions << :cancel if can?(:cancel, r)
    permissions << :decline if can?(:decline, r)
    json.array! permissions
  end
end

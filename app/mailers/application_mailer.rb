# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "tab@zeus.ugent.be"
  layout "mailer"
end

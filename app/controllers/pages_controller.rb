class PagesController < ApplicationController

  require 'statistics'

  def landing
    @statistics = Statistics.new
  end

end

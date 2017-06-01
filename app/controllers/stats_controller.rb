class StatsController < ApplicationController
  def index
    @stats = connection.get_stats(params[:date_from], params[:date_to])
  end

  protected

  def last_6_months
    (0..5).map { |month| (5.months.ago + month.months).beginning_of_month }
  end
  helper_method :last_6_months
end

class SearchController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!, :except => [:show, :index]

  def index
    @app_url = params[:url] || "http://localhost:3000/jobs"
    @jobs = HTTParty.get(@app_url)
    @search_jobs = @jobs.select {|keyword| keyword["keywords"] == params[:keywords] }
    @job = @jobs.find {|job| job["id"] = params[:id] }
  end
end




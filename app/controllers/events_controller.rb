class EventsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!, :except => [:index]


  def index
    # Choose the URL to visit
    @app_url = params[:url] || "http://localhost:3000/events"
    # Ensure it starts with http
    @app_url = "http://#{@app_url}" unless @app_url.starts_with?("http")

    begin
      # Retrieve the webpage
      @events = HTTParty.get(@app_url)
    rescue StandardError
      # When something goes wrong create a fallback message
      @events = OpenStruct.new(:code => nil, :message => "Domain not found")
    end
    @event_hash = Hash.new(0)
    @events.each do |event|
      @event_hash[event["job"]] += 1
      @event_hash[event["click"]] += event["click"]
    end
  end
end





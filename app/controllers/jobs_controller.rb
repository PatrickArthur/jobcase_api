class JobsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :authenticate_user!, :except => [:show, :index]
  before_action :click_count, only: [:show]

  def index
    # Choose the URL to visit
    @app_url = params[:url] || "http://localhost:3000/jobs"
    # Ensure it starts with http
    @app_url = "http://#{@app_url}" unless @app_url.starts_with?("http")

    begin
      # Retrieve the webpage
      @jobs = HTTParty.get(@app_url)
    rescue StandardError
      # When something goes wrong create a fallback message
      @jobs = OpenStruct.new(:code => nil, :message => "Domain not found")
    end
  end

  def show
    @app_url = params[:url] || "http://localhost:3000/jobs"
    @jobs = HTTParty.get(@app_url)
    @job = @jobs.find {|job| [job["id"] = params[:id],
                              job["posted"] = params[:posted],
                              job["company"] = params[:company],
                              job["poster"] = params[:poster],
                              job["city"] = params[:city],
                              job["state"] = params[:state],
                              job["title"] = params[:title],
                              job["body"] = params[:body],
                              job["keywords"] = params[:keywords]] }
  end

   def create
    @app_url = params[:url] || "http://localhost:3000/jobs"
    @job = HTTParty.post(@app_url.to_str,
    :body => { :id => params[:id],
               :posted => params[:posted],
               :company => params[:company],
               :poster => params[:poster],
               :city => params[:city],
               :state => params[:state],
               :title => params[:title],
               :body => params[:body],
               :keywords => params[:keywords]
              }.to_json,
    :headers => { 'Content-Type' => 'application/json' } )
    redirect_to :action => :index
  end

  def click_count
    @app_url_events = params[:url] || "http://localhost:3000/events"
    @app_url_jobs = params[:url] || "http://localhost:3000/jobs"
    download = 0
    @jobs = HTTParty.get(@app_url_jobs)
    @job = @jobs.find {|job| [job["id"] = params[:id],
                              job["posted"] = params[:posted],
                              job["company"] = params[:company],
                              job["poster"] = params[:poster],
                              job["city"] = params[:city],
                              job["state"] = params[:state],
                              job["title"] = params[:title],
                              job["body"] = params[:body],
                              job["keywords"] = params[:keywords]] }
    @click = HTTParty.post(@app_url_events.to_str,
    :body => { :job => @job["id"],
               :click => download +=1
              }.to_json,
    :headers => { 'Content-Type' => 'application/json' } )
  end

end

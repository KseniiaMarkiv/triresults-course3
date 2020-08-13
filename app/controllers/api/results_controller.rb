module Api
  class ResultsController < ApplicationController

#  PUT    /api/races/:race_id/results/:id(.:format)   api/results#update {:format=>"json"}

# api_race_results GET /api/races/:race_id/results(.:format) api/results#index {:format=>"json"}
  def index
    if !request.accept || request.accept == "*/*"
        render plain: "/api/races/#{params[:race_id]}/results", status: :ok
    else
        # render plain: "/races/#{params[:race_id]}/results"
# rspec spec/resources_spec.rb 4punkt
      @race=Race.find(params[:race_id])
      @entrants=@race.entrants
# bundle exec rspec spec/caching_spec.rb -e rq01
      # fresh_when last_modified: @race.entrants.max(:updated_at)

# bundle exec rspec spec/caching_spec.rb -e rq02
      max_last_modified = @race.entrants.max(:updated_at)

        if_modified_since = request.headers['If-Modified-Since']
        puts "****#{if_modified_since}****"

        if stale?(last_modified: max_last_modified)
          @entrants=@race.entrants  
        end
    end
  end

#   api_race_result GET    /api/races/:race_id/results/:id(.:format)   api/results#show {:format=>"json"}
  def show
    if !request.accept || request.accept == "*/*"
        render plain: "/api/races/#{params[:race_id]}/results/#{params[:id]}", status: :ok
    else
        # render plain: "/races/#{params[:race_id]}/results/#{params[:id]}"
        # rspec spec/resources_spec.rb 1punkt
        @result=Race.find(params[:race_id]).entrants.where(:id=>params[:id]).first
        render :partial=>"result", :object=>@result
    end
  end

 # PATCH  /api/races/:race_id/results/:id(.:format)   api/results#update {:format=>"json"}
    def update
      entrant = Race.find(params[:race_id]).entrants.where(:id=>params[:id]).first
      
      result=params[:result]
      if result
        if result[:swim]
            entrant.swim=entrant.race.race.swim
            entrant.swim_secs = result[:swim].to_f
        end
        if result[:t1]
            entrant.t1=entrant.race.race.t1
            entrant.t1_secs = result[:t1].to_f
        end
        if result[:bike]
            entrant.bike=entrant.race.race.bike
            entrant.bike_secs = result[:bike].to_f
        end
        if result[:t2]
            entrant.t2=entrant.race.race.t2
            entrant.t2_secs = result[:t2].to_f
        end
        if result[:run]
            entrant.run=entrant.race.race.run
             entrant.run_secs = result[:run].to_f
        end        
          entrant.save
       render json: entrant, :status => :ok
      end
    end
		
	end 
end

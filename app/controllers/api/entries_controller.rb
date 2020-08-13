module Api
  class EntriesController < ApplicationController

# api_racer_entries GET    /api/racers/:racer_id/entries(.:format)     api/entries#index {:format=>"json"}
    def index
        if !request.accept || request.accept == "*/*"
          render plain: "/api/racers/#{params[:racer_id]}/entries", status: :ok
        else
          render plain: "/racers/#{params[:racer_id]}/entries"
        end
    end

#   api_racer_entry GET    /api/racers/:racer_id/entries/:id(.:format) api/entries#show {:format=>"json"}
    def show
        if !request.accept || request.accept == "*/*"
          render plain: "/api/racers/#{params[:racer_id]}/entries/#{params[:id]}", status: :ok
        else
          render plain: "/racers/#{params[:racer_id]}/entries/#{params[:id]}"
        end
    end

  end
end
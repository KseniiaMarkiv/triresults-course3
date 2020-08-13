module Api
	class RacersController  <  ApplicationController

		# protect_from_forgery with: :null_session  - we don't have to have this configure, because 
																								# use when implementing POST HTTP method actions from web service clients

#                   POST   /api/racers(.:format)                       api/racers#create {:format=>"json"}
#     new_api_racer GET    /api/racers/new(.:format)                   api/racers#new {:format=>"json"}
#    edit_api_racer GET    /api/racers/:id/edit(.:format)              api/racers#edit {:format=>"json"}
#                   PATCH  /api/racers/:id(.:format)                   api/racers#update {:format=>"json"}
#                   PUT    /api/racers/:id(.:format)                   api/racers#update {:format=>"json"}

# api_racers GET  /api/racers(.:format) api/racers#index {:format=>"json"}
		def index
			if !request.accept || request.accept == "*/*"
				render plain: "/api/racers", status: :ok 
			else
				#real implementation ...
				respond_with Racer.all
			end
	  end

# api_racer GET  /api/racers/:id(.:format) api/racers#show {:format=>"json"}
	  def show
			if !request.accept || request.accept == "*/*"
   			render plain: "/api/racers/#{params[:id]}", status: :ok # the same that api_racers_path(params[:id]) 
			else
				#real implementation ...
				@racer = Racer.find(params[:id])
        respond_with @racer, status: :ok 
			end
	  end



	end 
end

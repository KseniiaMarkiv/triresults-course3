module Api
	class RacesController  <  ApplicationController

    protect_from_forgery with: :null_session
    
    # bundle exec rspec spec/errors_spec.rb

    rescue_from ActionView::MissingTemplate do |exception|
      Rails.logger.debug exception
      @msg = "woops: we do not support that content-type[#{request.accept}]"
      render plain: @msg, status: :unsupported_media_type
    end

    rescue_from Mongoid::Errors::DocumentNotFound do |exception|
      @msg = "woops: cannot find race[#{params[:id]}]"
      if !request.accept || request.accept == "*/*"
        render plain: @msg, status: :not_found
      else
        respond_to do |format|
          format.json { render "error_msg", status: :not_found, content_type: "#{request.accept}" }
          format.xml  { render "error_msg", status: :not_found, content_type: "#{request.accept}" }
        end
      end
    end

# api_races GET /api/races(.:format) api/races#index {:format=>"json"}
		def index
      if !request.accept || request.accept == "*/*"
        offset = ", offset=[#{params[:offset]}]" if  params[:offset]
        limit = ", limit=[#{params[:limit]}]" if  params[:limit]
        render plain: "/api/races#{offset}#{limit}", status: :ok
        # render plain: "/api/races, offset=[#{params[:offset]}], limit=[#{params[:limit]}]", status: :ok
      else
        #real implementation ...
        respond_with Race.all
      end      
    end

# api_race GET    /api/races/:id(.:format) api/races#show {:format=>"json"} 
# action: :show - необходимо показывать, когда вызывает show.xml.builder, а не _race.xml.builder

    def show
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races/#{params[:id]}"
      elsif (request.accept.include? "application/xml") || (request.accept.include? "application/json")  # if request.accept == "application/json" - это НЕ одно и тоже
        @race = Race.find(params[:id])
        render "race", content_type: "#{request.accept}"
      end       
    end


# POST /api/races(.:format)  api/races#create {:format=>"json"}
    def create
      if !request.accept || request.accept =="*/*"
        # render plain: :nothing, status: :ok
          msg = ""
          if params[:race]
            if params[:race][:name]
              msg = params[:race][:name]
            end
          end
        render plain: msg, status: :ok        
        # render plain: "#{params[:race][:name]}", status: :ok  # DON'T PUT "#{params[:race][:name]}" NEVER!!!
      else !request.accept == nil && request.accept == "*/*"
        #real implementation  bundle exec rspec spec/params_spec.rb -e 02
        race=Race.new(race_params)
        race.save
        render plain: race.name, status: :created
      end
      
    end
# PATCH  /api/races/:id(.:format) api/races#update {:format=>"json"}
# PUT /api/races/:id(.:format) api/races#update {:format=>"json"}
    def update
        Rails.logger.debug("method=#{request.method}")
        race=Race.find(params[:id])
        race.update(race_params)
        render json: race, status: :ok
    end

# DELETE /api/races/:id(.:format) api/races#destroy {:format=>"json"}
    def destroy
        Rails.logger.debug("method=#{request.method}")
        Race.find(params[:id]).destroy
        render :nothing => true, :status => :no_content
    end

    private

      def race_params
        params.require(:race).permit(:name, :date)
      end
		
	end # class
end

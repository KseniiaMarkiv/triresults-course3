# json.partial! "racers/racer", racer: @racer
json.extract! @racer, :id, :first_name, :last_name, :gender, :birth_year, :city, :state, :created_at, :updated_at
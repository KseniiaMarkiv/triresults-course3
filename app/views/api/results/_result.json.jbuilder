json.source "partial: app/views/api/results/_result.json.jbuilder"

json.place @result.overall_place
json.time format_hours @result.secs
json.last_name @result.last_name
json.first_name @result.first_name
json.bib @result.bib
json.city @result.city
json.state @result.state
json.gener @result.racer_gender
json.gender_place @result.gender_place
json.group @result.group.name
json.group_place @result.group_place
json.swim format_hours @result.swim_secs
json.pace_100 format_minutes @result.swim_pace_100
json.t1 format_minutes @result.t1_secs
json.bike format_hours @result.bike_secs
json.mph format_mph @result.bike_mph
json.t2 format_minutes @result.t2_secs
json.run format_hours @result.run_secs
json.mmile format_minutes @result.run_mmile
json.result_url api_race_result_url(@result.race.id, @result)
if @result.racer.id
  json.racer_url api_racer_url(@result.racer.id)
end

# •	place - overall place
# •	time - time formatted (long) overall time
# •	last_name - entrant’s last_name
# •	first_name - entrant‘s first_name
# •	bib - bib number
# •	city - entrant’s city
# •	state - entrant’s state
# •	gender - entrant’s gender (Hint: entrant.racer_gender)
# •	gender_place - entrant’s placing within gender
# •	group - entrant’s group_name (Hint: entrant.group_name)
# •	group_place - entrant’s placing within group
# •	swim - time formatted (long) swim time
# •	pace_100 - time formatted (short) swim_pace_100
# •	t1 - time formatted (short) t1_secs
# •	bike - time formatted (long) bike_secs
# •	mph - formated bike_mph
# •	t2 - time formatted (short) t2_secs
# •	run - time formatted (long) run_secs
# •	mmile - time formatted (short) run_mmile
# •	result_url - url of this entrant’s race result
# •	racer_url - if entrant.racer.id is not nil

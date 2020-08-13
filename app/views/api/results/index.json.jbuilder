# app/views/api/results/result.json.jbuilder - если бы ты назвала контроллер по другому, а так у меня и так index app/views/api/results/index.json.jbuilder 
json.ignore_nil!   #don't marshal nil values
json.array!(@entrants) do |entrant|
  json.partial! "result", :locals=>{ :@result=>entrant }
end
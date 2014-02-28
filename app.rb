require 'sinatra'
require 'sinatra/activerecord'

Dir.glob('./{models}/*.rb').each { |file| require file }

set :database_file, 'database.yml'

get '/' do
  haml '', layout: :main
end

get '/code_changes' do
  @change_log = `cd ~/scoring; git log`
  haml :code_changes, layout: :main
end

get '/open_search_form' do
  haml :open_search_form, layout: :main
end

post '/search_in_production_log' do
  @search_results = `grep -A 5 -B 5 -m 100 '#{params[:search_string]}' analyzed_logs/scoring.log`.
                    gsub(params[:search_string], "<b>#{params[:search_string]}</b>").
                    split("\n--\n")
  haml :search_in_production_log, layout: :main
end

get '/bash_history' do
  @bash_history = File.read('analyzed_logs/bash_history').gsub("\n", '<br>')
  haml :bash_history, layout: :main
end
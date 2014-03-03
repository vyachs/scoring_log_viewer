require 'sinatra'
require 'sinatra/activerecord'
require 'will_paginate'
require 'will_paginate/active_record'

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
  bash_dir = 'bash_history_files/'
  @bash_files_list = Dir.glob("#{bash_dir}*").map { |f_path| f_path.split('/').last }
  @current_bash_file = params[:file_name] || @bash_files_list[0]
  @bash_file_content = File.read(bash_dir + @current_bash_file).gsub("\n", '<br>')
  haml :bash_history, layout: :main
end

get '/parse_audit_logs' do
  begin
    result = 'OK'
    AuditEvent.analyze_log_files
  rescue => e
    result = "#{e.message} #{e.backtrace}"
  end
  result
end

get '/audit' do
  @audit_events = AuditEvent.order('id DESC').paginate(page: params[:page], per_page: 30)
  haml :audit, layout: :main
end
require 'sinatra'
require 'sinatra/activerecord'
require 'will_paginate'
require 'will_paginate/active_record'

Dir.glob('./{models}/*.rb').each { |file| require file }

set :database_file, 'database.yml'

def get_or_post(path, opts={}, &block)
  get(path, opts, &block)
  post(path, opts, &block)
end

def logins_list(kind)
  @path = request.path_info
  @logins = AuditEvent.where(kind: kind)
                      .order('time_moment DESC')
                      .paginate(page: params[:page], per_page: 30)
  if params[:start_time].present?
    @logins = @logins.where(time_moment: DateTime.parse(params[:start_time])..DateTime.parse(params[:end_time]))
  end
  haml :audit, layout: :main
end


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
    AuditEvent.analyze_log_files(params[:year])
  rescue => e
    result = "#{e.message} #{e.backtrace}"
  end
  result
end

get '/parse_snort_logs' do
  begin
    result = 'OK'
    Penetration.analyze_log_files(params[:year])
  rescue => e
    result = "#{e.message} #{e.backtrace}"
  end
  result
end

get_or_post '/audit' do
  logins_list('successful_login')
end

get_or_post '/failed_logins' do
  logins_list('failed_login')
end

get_or_post '/penetrations' do
  @penetrations = Penetration.order('time_moment DESC').paginate(page: params[:page], per_page: 30)
  if params[:start_time].present?
    @penetrations = @penetrations.where(time_moment: DateTime.parse(params[:start_time])..DateTime.parse(params[:end_time]))
  end
  haml :penetrations, layout: :main
end
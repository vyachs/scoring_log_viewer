require 'sinatra'
require 'sinatra/activerecord'

Dir.glob('./{models}/*.rb').each { |file| require file }

set :database_file, 'database.yml'

get '/' do
  @uu = User.last
  haml :act1, layout: :main
end
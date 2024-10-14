require 'sinatra'
require 'sinatra/activerecord'
require 'json'

# Carrega os modelos
Dir["./app/models/*.rb"].each { |file| require file }

# Configurações de ambiente
set :database_file, './config/database.yml'

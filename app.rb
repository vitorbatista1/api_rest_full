require 'sinatra'
require 'sinatra/activerecord'
require './config/environment'

# Carrega os controladores
Dir["./controllers/*.rb"].each { |file| require file }

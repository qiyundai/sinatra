require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative 'cookbook'
require_relative 'recipe'
require_relative 'scrap_service'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

class Controller
  attr_accessor :cookbook

  def initialize(cookbook)
    @cookbook = cookbook
  end

  def list
    @cookbook.all
  end

  def create
    @cookbook.add_recipe(Recipe.new(
                           {
                             name: @view.ask_name,
                             description: @view.ask_description,
                             rating: @view.ask_rating,
                             prep_time: @view.ask_prep_time
                           }
                         ))
  end

  def import
    @scraper = ScrapeAllrecipesService.new(@view.ask_ingredient)
    first_layer = @scraper.call
    @view.show_online_recipes(first_layer)
    index = @view.pick_recipe
    @cookbook.add_recipe(Recipe.new(
                           {
                             name: first_layer[index][:name],
                             description: first_layer[index][:description],
                             rating: first_layer[index][:rating],
                             prep_time: @scraper.scrap_prep_time(@scraper.urls[index])
                           }
                         ))
  end

  def mark
    @cookbook.mark_as_done(@view.ask_done)
  end

  def destroy
    @cookbook.remove_recipe(@view.ask_index)
  end
end

#----------------------------------------------
controller = Controller.new(Cookbook.new)

get '/' do
  puts controller.list
end

get '/about' do
  erb :about
end

get '/team/:username' do
  puts params[:username]
  "The username is #{params[:username]}"
end

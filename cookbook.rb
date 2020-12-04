require 'csv'
require 'open-uri'

class Cookbook
  attr_accessor :recipes

  def initialize(path_of_recipes)
    @recipes = []
    load_file(path_of_recipes)
    @path = path_of_recipes
  end

  def all
    @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    save_file(@path)
  end

  def remove_recipe(index)
    @recipes.delete_at(index)
    save_file(@path)
  end

  def mark_as_done(index)
    @recipes[index].done = true
  end

  private

  def load_file(file_path)
    CSV.foreach(file_path) do |row|
      @recipes << Recipe.new(
        {
          name: row[0],
          description: row[1],
          rating: row[2],
          prep_time: row[3]
        }
      )
    end
  end

  def save_file(file_path)
    CSV.open(file_path, 'w') do |csv|
      @recipes.each { |recipe| csv << [recipe.name, recipe.description, recipe.rating, recipe.prep_time] }
    end
  end
end

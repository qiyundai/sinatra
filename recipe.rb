class Recipe
  attr_accessor :name, :description, :rating, :prep_time, :done

  def initialize(att = {})
    @name = att[:name]
    @description = att[:description]
    @rating = att[:rating]
    @prep_time = att[:prep_time]
    @done = false
  end

  def done?
    @done
  end
end

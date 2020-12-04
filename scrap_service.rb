require 'open-uri'
require 'nokogiri'

class ScrapeAllrecipesService
  attr_reader :urls

  def initialize(keyword)
    @keyword = keyword
    @urls = []
  end

  def call
    # TODO: return a list of `Recipes` built from scraping the web.
    url = "https://www.allrecipes.com/search/results/?wt=#{@keyword}"
    Nokogiri::HTML(open(url).read).search('.fixed-recipe-card').first(5).map do |element|
      @urls << element.at('.fixed-recipe-card__title-link').attribute('href').value
      {
        name: element.at('.fixed-recipe-card__h3').text.strip,
        description: element.at('.fixed-recipe-card__description').text.strip,
        rating: element.at('.stars').attribute('data-ratingstars').value.to_f.round(2)
      }
    end
  end

  def scrap_prep_time(url)
    Nokogiri::HTML(open(url).read).at('.recipe-meta-item-body').text.strip
  end
end

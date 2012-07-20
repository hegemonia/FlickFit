class Genre < ActiveRecord::Base
  validates_uniqueness_of :name

  def self.in_comma_separated_list(list)
    list.split(",").map do |name|
      genre_name = Genre.prettify name
      Genre.find_by_name(genre_name) || Genre.create(:name => genre_name)
    end
  end

  private

  def self.prettify(name)
    name.gsub(/[-|_]/, " ").downcase.strip.capitalize
  end
end
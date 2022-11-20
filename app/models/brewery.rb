class Brewery < ApplicationRecord
  include RatingAverage
  validates :name, length: { minimum: 1 }
  validate :year_should_be_between_1040_and_current_date
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def year_should_be_between_1040_and_current_date
    return unless year < 1040 || year > Date.current.year

    errors.add(:year, " needs to be between 1040 and current date")
  end

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2022
    puts "changed year to #{year}"
  end
end

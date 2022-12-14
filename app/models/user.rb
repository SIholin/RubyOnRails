class User < ApplicationRecord
  include RatingAverage
  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }
  validates :password, length: { minimum: 4 }, format: { with: /(?=.*?[A-Z])/, message: "add at least one uppercase letter!" }
  has_many :ratings, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :beer_clubs, through: :memberships
  has_secure_password

  def favorite_beer
    return nil if ratings.empty?

    ratings.max_by(&:score).beer
  end

  def favorite_style
    return nil if ratings.empty?

    styles = ratings.collect{ |r| r.beer.style }
    compare_styles(styles)
  end

  def compare_styles(styles)
    avg = 0
    s = ""
    styles.each do |style|
      oliot = ratings.select{ |r| r.beer.style == style }
      a = average(oliot)
      if a > avg
        avg = a
        s = style
      end
    end
    s
  end

  def favorite_brewery
    return nil if ratings.empty?

    breweries = ratings.collect{ |r| r.beer.brewery }
    compare_breweries(breweries)
  end

  def compare_breweries(breweries)
    avg = 0
    b = breweries.first
    breweries.each do |brewery|
      oliot = ratings.select { |r| r.beer.brewery == brewery }
      a = average(oliot)
      if a > avg
        avg = a
        b = brewery
      end
    end
    b
  end

  def average(oliot)
    sum = oliot.sum(&:score)
    count = oliot.count
    sum / count
  end
end

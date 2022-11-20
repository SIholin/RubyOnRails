module RatingAverage
  extend ActiveSupport::Concern

  def average_rating(ratings)
    ratings.average(:score).to_f
  end
end

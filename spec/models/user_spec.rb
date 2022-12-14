require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"
    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"
    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){FactoryBot.create(:user)}
   
    it "is saved with a proper password" do
      expect(user).to be_valid 
      expect(User.count).to eq(1)
    end

    it "with a proper password and two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)
 
      expect(user.ratings.count).to eq(2)
      expect(user.average_rating(user.ratings)).to eq(15.0)
    end
  end

  it "is not saved with a too short password" do
    user = User.create username: "Pekka", password: "S1", password_confirmation: "S1"
    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is not saved with a lowercase password" do
    user = User.create username: "Pekka", password: "salasana", password_confirmation: "salasana"
    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  describe "favorite beer" do
    let(:user) { FactoryBot.create(:user) }
    it "has method for determinig the favorite_beer" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have a favorite beer" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rates if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({user: user}, 10, 20, 15)
      best = create_beer_with_rating({user: user}, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user) { FactoryBot.create(:user) }
    it "has method for determinig the favorite_style" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have a favorite beer" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rates if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings({user: user}, 10, 20, 15)
      best = FactoryBot.create(:beer, style: 'eka')
      rating = FactoryBot.create(:rating, score: 44, beer: best, user: user)
      expect(user.favorite_style).to eq(best.style)
    end
  end

  describe "favorite brewery" do
    let(:user) { FactoryBot.create(:user) }
    it "has method for determinig the favorite_brewery" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have a favorite brewery" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the only rates if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
      expect(user.favorite_brewery).to eq(beer.brewery)
    end

    it "is the one with highest rating if several rated" do
      b1 = FactoryBot.create(:brewery, name: 'hei')
      create_beers_with_many_ratings({user: user}, 10, 20, 15)
      best = FactoryBot.create(:beer, brewery: b1)
      rating = FactoryBot.create(:rating, score: 44, beer: best, user: user)
      expect(user.favorite_brewery).to eq(best.brewery)
    end
  end

  def create_beer_with_rating(object, score)
    beer = FactoryBot.create(:beer)
    FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
    beer
  end

  def create_beers_with_many_ratings(object, *scores)
    scores.each do |score|
      create_beer_with_rating(object, score)
    end
  end

 end

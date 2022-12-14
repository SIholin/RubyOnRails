require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: 'Pekka', password: 'Foobar1')
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating(beer1.ratings)).to eq(15.0)
  end

  it "is visible in ratings page" do
    FactoryBot.create(:rating, score: 12, beer: beer1, user: user)
    FactoryBot.create(:rating, score: 22, beer: beer1, user: user)
    FactoryBot.create(:rating, score: 2, beer: beer2, user: user)

    visit ratings_path

    expect(page).to have_content 'Total: 3'
    expect(page).to have_content 'iso 3 12 Pekka'
    expect(page).to have_content 'iso 3 22 Pekka'
    expect(page).to have_content 'Karhu 2 Pekka'
  end
end
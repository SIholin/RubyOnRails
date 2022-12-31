require 'rails_helper'

include Helpers

describe "User" do
  let!(:user) {FactoryBot.create :user}
  let!(:brewery) {FactoryBot.create :brewery}
  let!(:style) {FactoryBot.create :style}
  let!(:beer1) {FactoryBot.create :beer, brewery: brewery } 
  let!(:beer3) {FactoryBot.create :beer, brewery: brewery, style: style } 
  let!(:r1) {FactoryBot.create :rating, score: 2, beer: beer1, user: user}
  let!(:r2) {FactoryBot.create :rating, score: 11, beer: beer1, user: user}
  let!(:r3) {FactoryBot.create :rating, score: 49, beer: beer3, user: user}

  before :each do
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: 'Pekka', password: 'Foobar1')

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end
    it "is redirected back to signin form if wrong credentials given" do
        sign_in(username: 'Pekka', password: 'wrong')
  
        expect(current_path).to eq(signin_path)
        expect(page).to have_content 'Username and/or password mismatch'
    end
  end
  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret55')
    fill_in('user_password_confirmation', with: 'Secret55')
  
    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  it "has made ratings" do
    user2 = FactoryBot.create(:user, username: 'Heidi')
    r3 = FactoryBot.create(:rating, score: 24, beer: beer1, user: user2)
    sign_in(username: 'Pekka', password: 'Foobar1')
    visit user_path(user)
    expect(page).to have_content 'Has made 3 ratings,'
  end
  it "has not made ratings" do
    user2 = FactoryBot.create(:user, username: 'Heidi')
    sign_in(username: 'Pekka', password: 'Foobar1')
    visit user_path(user2)
    expect(page).to have_content 'has not made any ratings!'
  end

  it "can delete rating" do
    sign_in(username: 'Pekka', password: 'Foobar1')
    visit user_path(user)
    
    expect{
      page.all('button', text: 'delete')[0].click
    }.to change{Rating.count}.from(3).to(2)
    
  end

  it "has favorite beer style and brewery" do
    user2 = FactoryBot.create(:user, username: 'Heidi')
    
    sign_in(username: 'Pekka', password: 'Foobar1')
    visit user_path(user2)
    expect(page).to have_content 'has not made any ratings!'

    visit user_path(user)
    expect(page).to have_content 'Favorite beer style: Lager'
    expect(page).to have_content 'Favorite brewery: anonymous'
  end

end
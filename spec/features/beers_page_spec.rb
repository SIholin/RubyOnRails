require 'rails_helper'

include Helpers

describe "Beer" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:style) { FactoryBot.create :style, name: "Weizen" }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: 'Pekka', password: 'Foobar1')
  end

  it "can be created with unempty name" do
    visit new_beer_path
    select('Koff', from: 'beer[brewery_id]')
    select('Weizen', from: 'beer[style_id]')
    fill_in('beer[name]', with: 'Nami')
    click_button "Create Beer"
    expect(Beer.count).to eq(1)
  end

  it "cannot be created with empty name" do
    visit new_beer_path
    select('Koff', from: 'beer[brewery_id]')
    select('Weizen', from: 'beer[style_id]')
    click_button "Create Beer"
    expect(Beer.count).to eq(0)
    expect(page).to have_content 'error prohibited this beer from being saved'
  end

end
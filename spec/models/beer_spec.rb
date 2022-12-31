require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "is saved with a proper info" do
    brewery = Brewery.new name: "test", year: 2010
    style = Style.new name: "paha", description: "juoma"
    beer = Beer.create name: "Kalja", style: style, brewery: brewery
    expect(beer).to be_valid 
    expect(Beer.count).to eq(1)
  end

  it "is not saved without a name" do
    brewery = Brewery.new name: "test", year: 2010
    style = Style.new name: "paha", description: "juoma"
    beer = Beer.create style: style, brewery: brewery
    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
    brewery = Brewery.create name: "test", year: 2010
    beer = Beer.create name:"Kalja", brewery: brewery
    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end

end

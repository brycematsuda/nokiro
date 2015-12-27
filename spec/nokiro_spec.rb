require 'nokiro'
require 'mechanize'
require 'json'

RSpec.describe Nokiro::Chart do

  before :all do
    # Only call the API once
    agent = Mechanize.new
    response = agent.get('https://www.kimonolabs.com/api/49eulam0?apikey=' + ENV['NOKIRO_API'])
    @json = JSON.parse(response.body)
    @chart = Nokiro::Chart.new
  end

  context "with no chart specified" do
    it "returns the daily singles chart url" do
      defaultUrl = @json["results"]["charts"].first["link"]
      expect(@chart.url).to eq defaultUrl
    end
  end

  it "has rankings" do
    expect(@chart.rankings).to be_truthy
  end

  context "with rankings" do
    it "contains a array of Rank objects" do
      expect(@chart.rankings.class).to eq(Array)
      expect(@chart.rankings.first.class).to eq(Nokiro::Rank)
    end
  end

  context "daily singles chart specified" do
    it "returns the daily singles chart url" do
      daily_singles_url = @json["results"]["charts"][0]["link"]
      @chart = Nokiro::Chart.new("jsd")
      expect(@chart.url).to eq daily_singles_url
    end

    it "contains 30 rankings" do
      expect(@chart.rankings.length).to eq(30)
    end
  end

  context "weekly singles chart specified" do
    it "returns the weekly singles chart url" do
      weekly_singles_url = @json["results"]["charts"][1]["link"]
      @chart = Nokiro::Chart.new("jsw")
      expect(@chart.url).to eq weekly_singles_url
    end

    it "contains 50 rankings" do
      @chart = Nokiro::Chart.new("jsw")
      expect(@chart.rankings.length).to eq(50)
    end
  end

  context "daily albums chart specified" do
    it "returns the daily albums chart url" do
      daily_album_url = @json["results"]["charts"][2]["link"]
      @chart = Nokiro::Chart.new("jad")
      expect(@chart.url).to eq daily_album_url
    end

    it "contains 30 rankings" do
      expect(@chart.rankings.length).to eq(30)
    end
  end

  context "weekly albums chart specified" do
    it "returns the weekly albums chart url" do
      weekly_album_url = @json["results"]["charts"][3]["link"]
      @chart = Nokiro::Chart.new("jaw")
      expect(@chart.url).to eq weekly_album_url
    end

    it "contains 50 rankings" do
      @chart = Nokiro::Chart.new("jaw")
      expect(@chart.rankings.length).to eq(50)
    end
  end
end

RSpec.describe Nokiro::Rank do
  before :all do
    @rank = Nokiro::Rank.new("Test Title", "Test Artist", "5")
  end

  it "has a rank number" do
    expect(@rank.num).to be_truthy
    expect(@rank.num).to eq("5")
  end

  it "has a title" do
    expect(@rank.title).to be_truthy
    expect(@rank.title).to eq("Test Title")
  end

  it "has an artist" do
    expect(@rank.artist).to be_truthy
    expect(@rank.artist).to eq("Test Artist")
  end
end
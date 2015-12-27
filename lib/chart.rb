require 'nokogiri'
require 'mechanize'
require 'rank'

class Chart
  attr_reader :url, :rankings

  def initialize(chart = nil)
    agent = Mechanize.new
    response = agent.get('https://www.kimonolabs.com/api/49eulam0?apikey=' + ENV['NOKIRO_API'])
    json = JSON.parse(response.body)
    idx = 0
    pages = 0

    case chart
    when "jsd" # Daily singles
      idx = 0
      pages = 3
    when "jsw" # Weekly singles
      idx = 1
      pages = 5
    when "jad" # Daily albums
      idx = 2
      pages = 3
    when "jaw" # Weekly albums
      idx = 3
      pages = 5
    else
      idx = 0 # Default: daily singles
      pages = 3
    end

    @url = json["results"]["charts"][idx]["link"]
    @rankings = url_to_ranks(@url)

    2.upto(pages) do |page|
      @rankings += url_to_ranks(@url + "p/" + page.to_s + "/")
    end
  end
  
  def url_to_ranks(url)
    utr_agent = Mechanize.new
    rank_list = []

    utr_agent = utr_agent.get(url)
    utr_agent.search('section.box-rank-entry h2.title').children.each do |c|
      rank_list.push(Rank.new(c.text))
    end

    return rank_list
  end
end
require "sinatra"
require "erb"
require "json"

require_relative "analyze.rb"

raw_data = JSON.parse(File.read("raw_data.json"))
an = Analyzer.new(raw_data)

get '/' do
  erb :index, :locals => {:all_north_south_plots_links => an.getAllPlotsNorthSouth, :alphabetic_ordering => an.getAllPlotsAlphabetic, :an => an, :max_and_min_values => an.getMaxMinValues}
end
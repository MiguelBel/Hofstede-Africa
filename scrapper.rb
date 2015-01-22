require "pp"
require "net/http"
require "nokogiri"

raw_date = "angola.html => Angola
Burkina_Faso.html => Burkina Faso
Cape_Verde.html => Cape Verde
ethiopia.html => Ethiopia
ghana.html => Ghana
kenya.html => Kenya
libya.html => Libya
malawi.html => Malawi
morocco.html => Morocco
mozambique.html => Mozambique
Namibia.html => Namibia
nigeria.html => Nigeria
senegal.html => Senegal
sierra-leone.html => Sierra Leone
south-africa.html => South Africa
tanzania.html => Tanzania
zambia.html => Zambia"

splitted_raw_titles = raw_date.split("\n").collect{|single_raw| single_raw.split(" => ").reverse}

def get_raw_web(affix)
  return Nokogiri::HTML(Net::HTTP.get(URI.parse("http://geert-hofstede.com/" + affix)))
end

def get_hofstede_data(raw_web)
  return raw_web.search("script")[7].text.split("{").last.split("}").first.split("\n\t")[1..-1].collect{|data| data.gsub("\t", "").gsub(",", "").gsub("'", "")}.collect{|data| data.split(":").collect{|re_data| re_data.strip}}
end

info = []

splitted_raw_titles.each do |single_petition|
  info.push(get_hofstede_data(get_raw_web(single_petition[1])))
end

pp info
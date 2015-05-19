require 'open-uri'
require 'nokogiri'
require 'robotex'

robotex = Robotex.new
p robotex.allowed?("https://www.goodfind.jp/2016/seminar/")

url = "https://www.goodfind.jp/2016/seminar/"
user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'

open('output_seminar.txt', 'w') do |file|
	charset = nil
	html = open(url, "User-Agent" => user_agent) do |f|
		charset = f.charset
		f.read
	end

	doc = Nokogiri::HTML.parse(html, nil, charset)

	doc.css("#toggle_view_section > div.toggle.list_view > div > div > ul > li > a > div.seminar_desc > h3").each do |title|
		puts title.text
		file.write "#{title.text},\n"
	end
end
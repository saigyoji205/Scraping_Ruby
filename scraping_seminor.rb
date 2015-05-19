#!/usr/bin/ruby

require 'open-uri'
require 'nokogiri'
require 'robotex'
require 'sinatra'

get '/scraping_seminor' do
	url = "https://www.goodfind.jp/2016/seminar/"
	robotex = Robotex.new

	p robotex.allowed?(url)

	user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'

	charset = nil
	html = open(url,"User-Agent" => user_agent) do |f|
			charset = f.charset
			f.read
	end
	
	doc = Nokogiri::HTML.parse(html,nil,charset)
	
	html = "<h1>セミナーリスト</h1>"
	doc.css("#toggle_view_section > div.toggle.list_view > div > div > ul > li > a").each do |a_tag|
		html << "<p><a href=#{a_tag.attr('href')}><span>#{a_tag.text}</span></a></p>"
	end
	return html
end
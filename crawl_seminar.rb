#!/usr/bin/ruby

require 'open-uri'
require 'nokogiri'
require 'sqlite3'
require 'json'
urls =[]

db = SQLite3::Database.new('crawling.db')
db.execute('CREATE TABLE IF NOT EXISTS seminars (title varchar(100), image_url varchar(200))')

### 1650~1699の範囲でページを配列urlsに格納
(1650 ... 1699).each do |parameta|
	urls.push("https://www.goodfind.jp/2016/seminar/" + parameta.to_s)
end


urls.each_with_index do |url,index|
	charset = nil
	begin
		### 格納したページをオープン
		html = open(url) do |f|
			charset = f.charset
			f.read
		end
		
		### HTMLページをタグ構造ごとに分解
		doc = Nokogiri::HTML.parse(html,nil,charset)
		puts doc.css('title').text
		
		### <img src = data> 
		img_url = doc.css('#detail_top > img').attr('src')
		full_image_url = url + img_url
		puts full_image_url
		
		db.execute 'INSERT INTO seminars values ( ?, ? );', ["#{doc.css('title').text}", "#{full_image_url}"]
		rescue
			puts "error"
	end
end
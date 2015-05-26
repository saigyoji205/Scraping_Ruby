#!/usr/bin/ruby

require 'open-uri'
require 'nokogiri'
require 'sqlite3'
require 'json'
require 'robotex'
urls =[]

db = SQLite3::Database.new('crawling_detail.db')
db.execute('CREATE TABLE IF NOT EXISTS seminars_presenter (title varchar(100), image_url varchar(200),presenter varchar(200),presenter_detail varchar(300))')

user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'
robotex = Robotex.new

### 1649~1699の範囲でページを配列urlsに格納
(1649 ... 1699).each do |parameta|
		urls.push("https://www.goodfind.jp/2016/seminar/" + parameta.to_s
)
end

### urlsからデータベースにtitleとimg_urlを格納
urls.each_with_index do |url,index|
	charset = nil
	begin
		### 格納したページをオープン
		html = open(url,"User-Agent=" => user_agent) do |f|
			charset = f.charset
			f.read
		end
		
		### HTMLページをタグ構造ごとに分解
		doc = Nokogiri::HTML.parse(html,nil,charset)
		
		#セミナータイトル
		puts doc.css('title').text
		
		### <img src = data> 
		img_url = doc.css('#detail_top > img').attr('src')
		full_image_url = url + img_url
		puts full_image_url
		
		### 登壇者&肩書き
		presenter = doc.css('#section_1 > div > p > span').text
		puts presenter
		
		### 登壇者詳細
		presenter_detail = doc.css('#section_2 > div > p > span').text
		puts presenter_detail
		
		p robotex.allowed?(url)
		
		
		db.transaction do
			sql = "insert into seminars_presenter values (?,?,?,?)"
			db.execute(sql,"#{doc.css('title').text}","#{full_image_url}","#{presenter}","#{presenter_detail}")
		end
		
		rescue
			puts "error"
	end
end
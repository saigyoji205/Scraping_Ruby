#!/usr/bin/ruby

# URLにアクセスするためのライブラリ
require 'open-uri'
# HTMLを解析(パース、スクレイピング)するライブラリ
require 'nokogiri'
# robots.txt(クロールされないように設定するファイル)の可否を確認するライブラリ
require 'robotex'

# スクレイピング先のURL
url = 'http://www.yahoo.co.jp/'
robotex = Robotex.new

# スクレイピング先のURLでrobots.txtの可否があるか調べる(true => なし、false => あり)
p robotex.allowed?(url)

# user_agentの偽装(http://www.openspc2.org/userAgent/)
user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'

charset = nil
# urlで取得したHTMLファイルを取得し、変数htmlに取得した構造データを代入
html = open(url,"User-Agent"=>user_agent) do |f|
	charset = f.charset #文字種別を取得
	f.read
end

# nokogiriで構造を分解し、変数docに代入
doc = Nokogiri::HTML.parse(html,nil,charset)


# nokogiriで分解したタグの中から'title'タグを抽出
puts doc.css('title').text
#!/usr/bin/ruby

# URLにアクセスするためのライブラリ
require 'open-uri'
# HTMLを解析(パース、スクレイピング)するライブラリ
require 'nokogiri'
# robots.txt(クロールされないように設定するファイル)の可否を確認するライブラリ
require 'robotex'
require 'sinatra'

get '/scraping_news_nikkei' do
	# スクレイピング先のURL
	url = 'http://www.yahoo.co.jp/'
	robotex = Robotex.new

	# スクレイピング先のURLでrobots.txtの可否があるか調べる(true => なし、false => あり)
	p robotex.allowed?(url)

	# user_agentの偽装(http://www.openspc2.org/userAgent/)
	user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'

	charset = nil
	# urlで取得したHTMLファイルを取得し、変数htmlに取得した構造データをコピー(URLページを丸々コピー)
	html = open(url,"User-Agent"=>user_agent) do |f|
		charset = f.charset #文字種別を取得
		f.read
	end

	# nokogiriで構造を分解し、変数docに代入
	doc = Nokogiri::HTML.parse(html,nil,charset)
	
	html = "<h1>ヤフーニュース一覧</h1>"

	# nokogiriで分解したタグの中から'<ul class=emphasis>'内の'<a>タグを抽出、each文でul_tagに代入
	doc.css('#CONTENTS_MAIN > div > div > p').each{|p_tag|
		html << "<p>#{p_tag.text}</p>"
	}
	
	#整形したHTMLを出力
	return html
end
# ↑puts doc.css('#topicsfb > div.topicsindex > ul.emphasis').text

class VersesController < ApplicationController
	def created_verses
    #10.times do |i|
     # Verse.create title: 'Verrse'+i.to_s, text: 'Text'+i.to_s
     # end
  #agent = Mechanize.new
  #ulr = 'https://istihi.ru'
  #hash = Hash.new
  #page = agent.get(ulr + '/pushkin')
  #review_links_albums = page.search('.dotted li a')
  #review_links_albums.each do |l|
  #  page1= agent.get(ulr+l.attr(:href))
  #  review_links_albums1 = page1.search('.poem-text')
  #  review_links_albums1.each do |l1|
  #    hash[l.text] = l1.text
  #  end
  #end
  #hash.each do |key, value|
  #  Verse.create title: key, text: value
  #end
 @verse = Verse.where(id:1382)
 #term="Милый %WORD%, сегодня"
 term="И %WORD%, наследие отцов,\r\nИ %WORD%, и даже кучеров -"
 term=term.gsub('%WORD%','%%')
 x=Verse.where( 'text LIKE ?', '%'+term+'%' )
 puts x[0].title
 #p = @verse[0].text.split("\n")
 #puts p[0]
  end
end

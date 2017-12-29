class VerseController < ApplicationController
  skip_before_action :verify_authenticity_token
  def created_verse
    agent = Mechanize.new
    ulr = 'https://istihi.ru'
    hash = Hash.new
    hash_one = Hash.new
    hash_two = Hash.new
    page = agent.get(ulr + '/pushkin')
    review_links_albums = page.search('.dotted li a')
    review_links_albums.each do |l|
      page1= agent.get(ulr+l.attr(:href))
      review_links_albums1 = page1.search('.poem-text')
      review_links_albums1.each do |l1|
        hash[l.text] = l1.text
          str = ""
          str1 = ""
          l1.text.split("\r\n").each do |e1| 
            str+=str_rev(e1)+"\r\n"
            str1+=str_rev1(e1)+"\r\n"
          end
          hash_one[l.text] = str
          hash_two[l.text] = str1


      end
    end
    hash.each do |key, value|
      Verse.create(:title => key, :text => value, :text1 => hash_one[key], :text2 => hash_two[key])
    end
  end
 def del_log
  Log.delete_all
 end 


 def str_rev(str)
  str.gsub!(/[\«\»\~\!\@\#\$\^\&\*\(\)\_\+\`\-\=\№\;\?\/\,\.\/\;\'\\\|\{\}\:\"\[\]\<\>\?\—]/,"")
  str1 = ""
  str.split(" ").each{ |r| str1 += r.split("").sort.join}
  return str1
 end

  def str_rev1(str)
  str.gsub!(/[\«\»\~\!\@\#\$\^\&\*\(\)\_\+\`\-\=\№\;\?\/\,\.\/\;\'\\\|\{\}\:\"\[\]\<\>\?\—\s ]/,"")
  str = str.split("").sort.join
  return str
 end


  def v_post
    @API_KEY = '5745edbd23c3b934a93c8dcacfe93ceb'
  	@TASK_ID = request['id']
  	@answer = "Илья"
  	
        if(request['level'] == 1)
   
 
    end


     logger.info " answer = #{@answer}" 
 logger.info "task id = #{@TASK_ID}"
  	#puts "{ 'answer'  => '#{@answer}',  'token'   => #{@API_KEY},  'task_id' => #{@TASK_ID} }"
  	uri = URI("http://pushkin.rubyroidlabs.com/quiz")
parameters = {
  answer: "#{@answer}",
  token: @API_KEY,
  task_id:  @TASK_ID
}
Net::HTTP.post_form(uri, parameters)

    #str = "Уровень: " + request['level'] + ". Строка вопроса: " + request['question'] + ". Строка ответа: " +  @answer
   str = request['question'] + "<--> " + @answer
  Log.create(:text => str)
  end

end
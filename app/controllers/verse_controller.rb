class VerseController < ApplicationController
  skip_before_action :verify_authenticity_token
  def created_verse
    agent = Mechanize.new
    ulr = 'https://istihi.ru'
    hash = Hash.new
    page = agent.get(ulr + '/pushkin')
    review_links_albums = page.search('.dotted li a')
    review_links_albums.each do |l|
      page1= agent.get(ulr+l.attr(:href))
      review_links_albums1 = page1.search('.poem-text')
      review_links_albums1.each do |l1|
        hash[l.text] = l1.text
      end
    end
    hash.each do |key, value|
      Verse.create title: key, text: value
    end
  end

 
  def v_post
    @API_KEY = '5745edbd23c3b934a93c8dcacfe93ceb'
  	@TASK_ID = request['id']
  	@answer = "Илья"
  	
    if(request['level'] == '1')
      question = request['question']
	  question.gsub!('%WORD%','%%')
      result = Verse.where( 'text LIKE ?', '%'+question+'%' )
      unless result.first.blank? then @answer = result.first.title end
    
    end
  	#puts "{ 'answer'  => '#{@answer}',  'token'   => #{@API_KEY},  'task_id' => #{@TASK_ID} }"
  	uri = URI("http://pushkin.rubyroidlabs.com/quiz")
parameters = {
  answer: @answer,
  token: @API_KEY,
  task_id:  @TASK_ID
}
Net::HTTP.post_form(uri, parameters)
 logger.info " answer = #{@answer}" 
 logger.info "task id = #{@TASK_ID}"
    #str = "Уровень: " + request['level'] + ". Строка вопроса: " + request['question'] + ". Строка ответа: " +  @answer
    #Log.create(:text => "Hello")
  end

end
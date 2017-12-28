 require 'net/http'
 require 'uri' 
class VerseController < ApplicationController
  skip_before_action :verify_authenticity_token
  def created_verse
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
  	url = "http://pushkin.rubyroidlabs.com/quiz"

 uri = URI.parse(url)
 http = Net::HTTP.new(uri.host, uri.port)
 request = Net::HTTP::Post.new(uri.request_uri)
 parameters =  {"answer"=>"#{@answer}", "token"=>@API_KEY, "task_id"=> @TASK_ID}
 request.set_form_data(parameters)    
 response = http.request(request)

 logger.info @TASK_ID
    #str = "Уровень: " + request['level'] + ". Строка вопроса: " + request['question'] + ". Строка ответа: " +  @answer
    #Log.create(:text => "Hello")
  end

end
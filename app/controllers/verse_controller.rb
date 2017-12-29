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
      Verse.create(:title => key, :text => value)
    end
  end
 def del_log
  Log.delete_all
 end 
 
  def v_post
    @API_KEY = '5745edbd23c3b934a93c8dcacfe93ceb'
  	@TASK_ID = request['id']
  	@answer = "Илья"
  	
    if(request['level'] == 1)
      question = request['question']
      question = question
	  question.gsub!('%WORD%','%%')
      result = Verse.where( 'text LIKE ?', '%'+question+'%' )
      unless result.first.blank? then @answer = result.first.title end
    
        elsif(request['level'] == 2)
      question = request['question']
      question = question.gsub('%WORD%','%%')
      result = Verse.where( 'text LIKE ?', '%'+question+'%' )
      position_one = request['question'].gsub("%WORD%","(\w+|[а-яА-Я]+)")
      result.first.text.split("\r\n").each do |e| 
        unless e.scan(/#{position_one}/).blank? then @answer =e.scan(/#{position_one}/)[0][0] end
      end
        elsif(request['level'] == 3)
      question = request['question']
      question = question.gsub("\n","\r\n")
    question = question.gsub('%WORD%','%%')
    word_one = ""
    word_second = ""
    search = "%%"
    arr_pos = []
      question.split(' ').each_index do |x|
        if question.split(' ')[x] == search then arr_pos.push(x) end
      end
      result = Verse.where( 'text LIKE ?', '%'+question+'%' )
      unless result.first.blank?
        position_one = request['question'].split("\n").first.sub("%WORD%","(\w+|[а-яА-Я]+)")
        position_second = request['question'].split("\n").at(1).sub("%WORD%","(\w+|[а-яА-Я]+)")
        result.first.text.split("\r\n").each do |e| 
          unless e.scan(/#{position_one}/).blank? then word_one =e.scan(/#{position_one}/)[0][0] end
          unless e.scan(/#{position_second}/).blank? then word_second =e.scan(/#{position_second}/)[0][0] end
        end
      end
      @answer = "#{word_one},#{word_second}"
 elsif(request['level'] == 4)
      question = request['question']
    question = question.gsub("\n","\r\n")
    question = question.gsub('%WORD%','%%')
    search = "%%"
    arr_pos = []
    word_one = ""
    word_second = ""
    word_three = ""
      question.split(' ').each_index do |x|
        if question.split(' ')[x] == search then arr_pos.push(x)  end
      end
      result = Verse.where( 'text LIKE ?', '%'+question+'%' )
      unless result.first.blank?
        position_one = request['question'].split("\n").first.sub("%WORD%","(\w+|[а-яА-Я]+)")
        position_second = request['question'].split("\n").at(1).sub("%WORD%","(\w+|[а-яА-Я]+)")
        position_three = request['question'].split("\n").at(2).sub("%WORD%","(\w+|[а-яА-Я]+)") 
        result.first.text.split("\r\n").each do |e| 
        unless e.scan(/#{position_one}/).blank? then word_one = e.scan(/#{position_one}/)[0][0] end
          unless e.scan(/#{position_second}/).blank? then word_second = e.scan(/#{position_second}/)[0][0] end
          unless e.scan(/#{position_three}/).blank? then word_three =e.scan(/#{position_three}/)[0][0] end
        end
      end
      @answer = "#{word_one},#{word_second},#{word_three}"
    elsif(request['level'] == 5)
      question = request['question']
      question = question.gsub("\n","\r\n")
    word_one = ""
    word_second = ""
    term1 = ""
    arr_pos = question.split(' ')
    arr_pos.each do |e| 
    term1 = question.gsub(arr_pos[arr_pos.rindex(e)],'%%')
    result = Verse.where( 'text LIKE ?', '%'+term1+'%' )
        unless result.first.blank? 
          position_one = term1.gsub("%%","(\w+|[а-яА-Я]+)")
          result.first.text.split("\r\n").each do |e|
            unless e.scan(/#{position_one}/).blank? then word_second = e.scan(/#{position_one}/)[0][0] end
          end
        word_one = arr_pos[arr_pos.rindex(e)].delete(",.:;!?\"\'—")
        end
    end
      @answer = "#{word_second},#{word_one}"
    elsif(request['level'] == 6)
      question = request['question']
      question = question.gsub("\n","\r\n")
    word_one = ""
    word_second = ""
      arr = question.split(' ')
    arr.each_index do |r| 
      word_one += arr[r].reverse 
        if r != arr.length-1
          word_one += "%%"
        end
      end
      result = Verse.where( 'text LIKE ?', '%'+word_one+'%' )
      unless result.first.blank?
        position_one = word_one.gsub("%%","([^\w]+)")
        result.first.text.split("\r\n").each do |e|
          unless e.scan(/#{position_one}/).blank? then word_second = e end
        end
      end
      @answer = "#{word_second}"
    elsif(request['level'] == 7)
      question = request['question']
      question = question.gsub("\n","\r\n")
    word_one = ""
    word_second = ""
    arr = question.split(' ')
    arr.each_index do |r| 
      word_one += arr[r]
        if r != arr.length-1
          word_one += "%%"
        end
      end
      word_one.reverse!
      result = Verse.where( 'text LIKE ?', '%'+word_one+'%' )
      unless result.first.blank?
        position_one = word_one.gsub("%%","([^\w]+)")
        result.first.text.split("\r\n").each do |e|
          unless e.scan(/#{position_one}/).blank? then word_second = e end
        end
    end
      @answer = "#{word_second}"
    elsif(request['level'] == 8)
      question = request['question']
      question = question.gsub("\n","\r\n")
    word_one = ""
    word_second = ""
    arr = question.split(' ')
    arr.each_index do |r| 
    word_one += arr[r]
        if r!=arr.length-1
          word_one += "%%"
        end
      end
      word_one = word_one.reverse
    word_one1 = word_one
      for t in 0..word_one1.length-1
        word_one1 = word_one
        word_one1 = word_one.gsub(word_one[t], '_')
        result = Verse.where( 'text LIKE ?', '%'+word_one1+'%' )
        unless result.first.blank?
          position_one = word_one1.gsub("_","(.)")
          position_one = position_one.gsub("%%","([^\w]+)")
          result.first.text.split("\r\n").each do |e|
            unless e.scan(/#{position_one}/).blank? then word_second = e; break; end
          end
        end
        unless result.first.blank? then break end
      end
      @answer = "#{word_second}"

 
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
   str = request['question'] + "::::: " + @answer
  Log.create(:text => str)
  end

end
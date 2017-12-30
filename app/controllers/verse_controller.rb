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
      question = request['question']
      question.gsub!('%WORD%','%')
      result = Verse.find_by( 'text LIKE ?', '%'+question+'%' )
      unless result.blank? then @answer = result.title end
    elsif(request['level'] == 2)
      question = request['question']
      question = question.gsub('%WORD%','%')
      result = Verse.find_by( 'text LIKE ?', '%'+question+'%' )
      position_one = request['question'].gsub("%WORD%","(\w+|[а-яА-Я]+)")
      result.text.split("\r\n").each do |e| 
        unless e.scan(/#{position_one}/).blank? then @answer =e.scan(/#{position_one}/)[0][0] end
      end
    elsif(request['level'] == 3)
      question = request['question']
      question = question.gsub("\n","\r\n")
      question = question.gsub('%WORD%','%')
      word_one = ""
      word_second = ""
      search = "%"
      arr_pos = []
      question.split(' ').each_index do |x|
        if question.split(' ')[x] == search then arr_pos.push(x) end
      end
      result = Verse.find_by( 'text LIKE ?', '%'+question+'%' )
      unless result.blank?
        puts result.title
        position_one = request['question'].split("\n").first.sub("%WORD%","(\w+|[а-яА-Я]+)")
        position_second = request['question'].split("\n").at(1).sub("%WORD%","(\w+|[а-яА-Я]+)")
        result.text.split("\r\n").each do |e| 
          unless e.scan(/#{position_one}/).blank? then word_one =e.scan(/#{position_one}/)[0][0] end
          unless e.scan(/#{position_second}/).blank? then word_second =e.scan(/#{position_second}/)[0][0] end
        end
      end
      @answer = "#{word_one},#{word_second}"
    elsif(request['level'] == 4)
      question = request['question']
      question = question.gsub("\n","\r\n")
      question = question.gsub('%WORD%','%')
      search = "%"
      arr_pos = []
      word_one = ""
      word_second = ""
      word_three = ""
      question.split(' ').each_index do |x|
        if question.split(' ')[x] == search then arr_pos.push(x)  end
      end
      result = Verse.find_by( 'text LIKE ?', '%'+question+'%' )
      unless result.blank?
        position_one = request['question'].split("\n").first.sub("%WORD%","(\w+|[а-яА-Я]+)")
        position_second = request['question'].split("\n").at(1).sub("%WORD%","(\w+|[а-яА-Я]+)")
        position_three = request['question'].split("\n").at(2).sub("%WORD%","(\w+|[а-яА-Я]+)") 
        result.text.split("\r\n").each do |e| 
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
        result = Verse.find_by( 'text LIKE ?', '%'+term1+'%' )
        unless result.blank? 
          position_one = term1.gsub("%%","(\w+|[а-яА-Я]+)")
          result.text.split("\r\n").each do |e|
            unless e.scan(/#{position_one}/).blank? then word_second = e.scan(/#{position_one}/)[0][0] end
          end
        word_one = arr_pos[arr_pos.rindex(e)].delete(",.:;!?\"\'—")
        end
      end
      @answer = "#{word_second},#{word_one}"
    elsif(request['level'] == 6)
      question = str_rev(request['question'])
      word_one = question 
      count = 0
      id_verse = 0
      result = Verse.find_by( 'text1 LIKE ?', '%'+word_one+'%' )
      unless result.blank?
        id_verse = result.id
        result.text1.split("\r\n").each do |e|
          unless e.scan(/#{word_one}/).blank? then break end
          count += 1
        end
      end
      result_second = Verse.find_by(id:id_verse )
      word = result_second.text.split("\r\n")[count]
      @answer = "#{word}"
    elsif(request['level'] == 7)
      question = str_rev1(request['question'])
      word_one = question 
      count = 0
      id_verse = 0
      result = Verse.find_by( 'text2 LIKE ?', '%'+word_one+'%' )
      unless result.blank?
        id_verse = result.id
        result.text2.split("\r\n").each do |e|
          unless e.scan(/#{word_one}/).blank? then break end 
          count += 1
        end
      end
      result_second = Verse.find_by(id:id_verse )
      word = result_second.text.split("\r\n")[count]
      @answer = "#{word}"
    elsif(request['level'] == 8)
      question = str_rev1(request['question'])
      word_one = question
      puts word_one
      stroka = ""
      count = 0
      id_verse = 1
      word_one_copy = word_one 
      for t in 0..word_one.size 
        for xx in 1..10
          word_one_copy = word_one.sub(word_one[t],'%')
          if t!=xx 
            word_one_copy[xx]='%'
          end
          result = Verse.find_by( 'text2 LIKE ?', '%'+word_one_copy+'%' )
          unless result.blank? then stroka = word_one_copy; break end
        end
        unless result.blank?
          word_one_copy = stroka
          id_verse = result.id
          position_one = word_one_copy.gsub("%","([\w]{0,10}|[а-яА-Я]{0,10})").delete(" ")
          result.text2.split("\r\n").each do |e|
            unless e.delete(" ").scan(/#{position_one}/).blank? then break end
            count += 1 
          end
          break
        end
        word_one_copy = word_one
      end   
      result_second = Verse.find_by(id:id_verse )
      word = result_second.text.split("\r\n")[count]
      @answer = "#{word}"
    end

    logger.info " answer = #{@answer}" 
    logger.info "task id = #{@TASK_ID}"
    logger.info "Count Verse= #{Verse.count}" 
  	uri = URI("http://pushkin.rubyroidlabs.com/quiz")
    parameters = {
      answer: "#{@answer}",
      token: @API_KEY,
      task_id:  @TASK_ID
    }
    Net::HTTP.post_form(uri, parameters)
    #str = "Уровень: " + request['level'] + ". Строка вопроса: " + request['question'] + ". Строка ответа: " +  @answer
   str = "lvl:" +request['level'] + " " + request['question'] + "<==> " + @answer
   Log.create(:text => str)
  end
end

class VerseController < ApplicationController
	def created_verse

  end
  def v_post
  	puts request['question']
  	logger.info('initialize') { "IXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" }
  end

end
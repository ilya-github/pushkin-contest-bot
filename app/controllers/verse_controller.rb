class VerseController < ApplicationController
	def created_verse

  end
  def v_post
  	
  	logger.info('initialize') { request['question'] }
  end

end
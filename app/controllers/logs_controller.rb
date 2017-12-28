class LogsController < ApplicationController
    def index
  	@logs = Log.order("id DESC").paginate(page: params[:page], per_page: 10)
  end

end

class HomesController < ApplicationController

  def index
    @notice = Notice.order(created_at: :desc).limit(5)
  end

end
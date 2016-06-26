class ActivitiesController < ApplicationController

  def index
    respond_to do |format|
      format.html # to initialize the ng app
      format.json {
        @activities = Activity.recent_ones(20)
        render json: @activities, include: [:user]
      }
    end
  end
end

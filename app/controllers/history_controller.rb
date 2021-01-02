class HistoryController < ApplicationController

  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:event_id])
    @histories = @event.histories
  end


end

class PagesController < ApplicationController
  skip_before_filter :authenticate!
  def index
    render text: '', layout: true
  end
end

class VandalismController < ApplicationController
  def index
    @vandalism = Vandalism.all

    @title = 'Pending Vandalism Fund Applications'
    @breadcrumbs = { 'Pending vandalism fund applications' => nil }
  end

  def index_abandonment
    @vandalism = []

    @title = 'Pending Abandonment Applications'
    @breadcrumbs = { 'Pending abandonment applications' => nil}

    render :index
  end

  def index_hazardous
    @vandalism = []

    @title = 'Pending Hazardous Monuments Applications'
    @breadcrumbs = { 'Pending hazardous applications' => nil}

    render :index
  end

  def index_vandalism
    @vandalism = []

    @title = 'Pending Vandalism Applications'
    @breadcrumbs = { 'Pending vandalism applications' => nil}

    render :index
  end
end

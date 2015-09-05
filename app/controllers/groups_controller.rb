class GroupsController < ApplicationController
  def new
    @group = Group.new
  end
  
  def create
    @group = Group.new(params[:group])
    if @group.save
      if params[:hashtags]
        Hashtag.add_from params[:hashtags], @group
      end
      if params[:local]
        set_location @group
      end
      redirect_to group_path(@group.token)
    else
      redirect_to :back
    end
  end
  
  def show
    reset_page
    @is_a_token = (params[:id].size > 5) ? true : false
    @group = Group.find_by_token(params[:id])
    unless @group.nil? or @group.expires?
      build_proposal_feed :all, @group
      @group_shown = true
    else
      redirect_to "/404"
    end
  end
end

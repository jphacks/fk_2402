class CommunitiesController < ApplicationController

  def index
    @user = current_user
    @communities = Community.paginate(page: params[:page])
  end

  def new
    @community = Community.new
  end

  def show
    @community = Community.find(params[:id])
    @user = User.find(@community.creator_id)
    @feed_items = current_user.feed.paginate(page: params[:page])
    @users ||= []
  end

  def create
    @user = current_user
    @community = Community.new(community_params)
    if @community.save
      @community.update_attribute(:creator_id, @user.id)
      flash[:success] = "Complete to create new Community!"
      redirect_to @community
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    Community.find(params[:id]).destroy
    flash[:success] = "Community deleted"
    redirect_to communities_url, status: :see_other
  end

  def followers
    @title = "Followers"
    @community  = Community.find(params[:id])
    @users = @community.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def community_params
    params.require(:community).permit(:name, :abstruct, :creator_id)
  end
end
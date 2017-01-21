class PostingsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  
  def create
    @posting = current_user.postings.build(posting_params)
    if @posting.save
      flash[:success] = "投稿　完了！！"
      redirect_to root_url
    else
      @feed_items = current_user.feed_items.includes(:user).order(created_at: :desc)
      render 'static_pages/home'
    end
  end
  
  def destroy
    @posting = current_user.postings.find_by(id: params[:id])
    return redirect_to root_url if @posting.nil?
    @posting.destroy
    flash[:sussess] = "投稿　削除しました。"
    redirect_to request.referrer || root_url
  end
  
  
  private
  def posting_params
    params.require(:posting).permit(:content)
  end
end

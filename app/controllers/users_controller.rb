class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :following, :followers]
  before_action :corrent_user, only: [:edit, :update]
  
  def show
    @user = User.find(params[:id])
    @areas = Region.all #地域の情報を取得
    @postings = @user.postings.order(created_at: :desc)
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "ユーザー登録いたしました！"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "登録情報　更新しました。"
      redirect_to@user
    else
      render 'edit'
    end
  end
  
  def index
    @users = User.order(created_at: :desc)
  end
  
  
  def following
    @title ="Following"
    @user = User.find(params[:id])
    @users = @user.following_users.page(params[:page])
    #@users = @user.following_users.page(params[:page]).per(5)
    render 'show_follow'
  end
  
  #20170105 課題：拡張　ページネーション追加
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.follower_users.page(params[:page])
    #@users = @user.follower_users.page(params[:page]).per(5)
    render 'show_follow'
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
  
  #ログイン済みのユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください！"
      redirect_to login_path
    end
  end
  
  #正しいユーザーかどうか確認
  def corrent_user
    # @user = User.find(params[:id])  存在していないとエラー
    @user = User.find_by(id: params[:id])   #存在していない IDではnil エラーにはしない
    redirect_to(root_url) unless (current_user == @user)
  end   
end

class UsersController < ApplicationController

  before_action :set_user, only: [:edit, :update, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]

  def show
    @articles = @user.articles.paginate(page: params[:page], per_page: 4)
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:danger] = "User and all articles created by this user, has been deleted"
    redirect_to users_path
  end

  def index 
    @users = User.paginate(page: params[:page], per_page: 4)
  end

  def new
    @user = User.new
  end

  def edit
  end

  def update 
    if @user.update(user_params)
      flash[:notice] = "Your account information was successfully updated"
      redirect_to user_path
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Welcome to the AlphaBlog #{ @user.username }, you have signed up successfully"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user && !current_user.admin?
      flash[:danger] = "You can only edit your own profile"
      redirect_to root_path
    end
  end

  def require_admin
    if logged_in? and !current_user.admin?
      flash[:danger] = "Only admin can perform that admin"
      redirect_to root_path
    end
  end
end
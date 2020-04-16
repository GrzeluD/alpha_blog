class UsersController < ApplicationController

  before_action :set_user, only: [:edit, :update, :show]

  def show
    @articles = @user.articles.paginate(page: params[:page], per_page: 4)
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
      flash[:notice] = "Welcome to the AlphaBlog #{ @user.username }, you have signed up successfully"
      redirect_to articles_path
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end

def set_user
  @user = User.find(params[:id])
end
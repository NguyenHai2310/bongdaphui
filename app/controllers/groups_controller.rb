class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  def new
    @group = Group.new
  end

  def destroy
    @group.destroy
    flash[:success] = "Deleted success"
    redirect_to root_path
  end

  def show
    @admin = @group.admin
  end

    def create
    @group = Group.new group_params
    @group.user_ids << current_user.id
    if @group.save
      UserGroup.create user_id: current_user.id, group_id: @group.id
      flash[:success] = "Group create success"
      redirect_to @group
    else
      flash[:danger] = "Create failed"
      render :new
    end
  end

    def update
    unless params[:confirm]
      if @group.update_attributes group_params
        flash[:success] = "Edited success"
        redirect_to @group
      else
        flash[:danger] = "Edit failed"
        render :edit
      end
    else
      @group.user_groups.find_by_user_id(current_user.id).destroy
      flash[:success] = "Leave group successfully"
      redirect_to root_path
    end
  end

  private

   def group_params
    params.require(:group).permit :name, :description, :admin_id, user_ids: [],
      user_groups_attributes: [:id, :user_id, :group_id]

  end

  def set_group
    @group = Group.find params[:id]
  end
end

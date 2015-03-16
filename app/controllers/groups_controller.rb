class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy, :admins]

  # GET /groups
  # GET /groups.json
  def index
    @groups = current_user.groups
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @ordered_group_members = sort_by_name(admins) + sort_by_name(@group.users - admins)
    @group_users = (@group.users - admins).size > 10 ? (@group.users - admins).shuffle : sort_by_name(@group.users - admins)
    @group_admins = admins.size > 10 ? sort_by_name(admins) : admins.shuffle
    @current_user_is_admin = admins.include?(current_user)
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    respond_to do |format|
      if @group.save
        @group.users.push(current_user)
        UserGroup.set_is_admin(@group.id, current_user.id, true)
        invite_members
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        invite_members
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    UserGroup.destroy_all(group_id: @group.id)
    GroupInvitation.where(group_id: @group.id).update_all(group_id: nil)
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def admins
    admin_ids = UserGroup.where(group_id: @group.id, is_admin: true).collect{|user_groups| user_groups.user_id}
    admins = Array.new
    admin_ids.each do |admin_id|
      admins.push(User.find(admin_id))
    end
    return admins
  end

  def join
    group_invitation = GroupInvitation.find_by_token!(params[:token])

    if group_invitation.expiry_date <= Time.now.in_time_zone
      flash[:error] = t('link_expired')
      redirect_to root_path
      return
    end

    if group_invitation.used == true
      flash[:error] = t('link_used')
      redirect_to root_path
      return
    end

    if group_invitation.group_id.nil?
      flash[:error] = t('group_deleted')
      redirect_to root_path
      return
    end

    group = Group.find(group_invitation.group_id)
    if group.users.include? current_user
      flash[:notice] = t('already_member')
    else
      group.users.push(current_user)
      flash[:success] = t('joined_group')
    end

    group_invitation.used = true
    group_invitation.save

    redirect_to group_path(group)


  rescue ActiveRecord::RecordNotFound => error
    flash[:error] = t('link_invalid')
    redirect_to root_path

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :imageId, :description, :primary_statistics)
    end

    def invited_members
      params[:members]
    end

    def invite_members
      return if invited_members.blank?
      emails = invited_members.split(/[^[:alpha:]]\s+|\s+|;\s*|,\s*/)
      expiry_date = 1.week.from_now.in_time_zone
      emails.each do |email_address|
        token = SecureRandom.urlsafe_base64(16)
        until GroupInvitation.find_by_token(token).nil? do
          token = SecureRandom.urlsafe_base64(16)
        end
        link = root_url + 'groups/join/' + token
        GroupInvitation.create(token: token, group_id: @group.id, expiry_date: expiry_date)
        UserMailer.group_invitation_mail(email_address, link, @group, current_user, root_url).deliver_now
      end

    end

    def sort_by_name members
      members.sort_by{ |m| [m.last_name, m.first_name] }
    end

end

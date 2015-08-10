module PageReaderGroupPermissions
  PageControllerExtensions = Proc.new do

    only_allow_access_to :new, :edit, :create, :update, :remove, :destroy,
      :if => :user_is_in_page_group,
      :denied_url => :back,
      :denied_message => "You must have group privileges to perform this action."

    def user_is_in_page_group
      return true if current_user.admin? || current_user.designer_or_developer?

      page = Page.find(params[:id] || params[:page_id] || params[:parent_id] || params[:page][:parent_id])

      until page.nil? do
        return true if page.editable_by_reader?(current_user.reader)
        page = page.parent
      end

      return false
    end

    before_filter :disallow_group_edits
    def disallow_group_edits
      if params[:page] && !current_user.admin?
        params[:page].delete(:group_id.to_s)
      end
    end
  end
  
  AdminReadersControllerExtensions = Proc.new do
    def build_user
      @reader = Reader.find params[:id]
      @user = @reader.build_user
      if @user
        if @user.save
          @reader.update_attribute(:user_id, @user.id)
          flash[:notice] = "Created user #{@user.login}"
        else
          flash[:error] = error_messages_for(:user)
        end
      end
      redirect_to edit_admin_reader_path(@reader.id)
    end
  end
end
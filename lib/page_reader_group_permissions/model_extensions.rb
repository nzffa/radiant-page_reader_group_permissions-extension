module PageReaderGroupPermissions
  PageModelExtensions = Proc.new do
    belongs_to :group

    def editable_by_reader?(reader)
      visible_to_reader?(reader)
    end

    def visible_to_reader?(reader)
      group && reader && visible_to?(reader)
    end

    def group_name
      self.group.nil? ? '' : self.group.name
    end
  end

  UserModelExtensions = Proc.new do
    def designer_or_developer?
      respond_to?(:designer?) ? designer? : developer?
    end
  end
  
  ReaderModelExtensions = Proc.new do
    def build_user
      return nil if user
  
      user_attrs = self.attributes.slice(*%w{name email created_at notes})
      random_pass = rand().to_s
      User.new(user_attrs.merge(:password => random_pass, :password_confirmation => random_pass, :login => email))
    end
  end
  
end
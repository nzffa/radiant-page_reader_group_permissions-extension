module PageReaderGroupPermissions
  PageModelExtensions = Proc.new do
    belongs_to :group

    def editable_by_reader?(reader)
      visible_to_reader?(reader)
    end

    def visible_to_reader?(reader)
      group && reader && group.visible_to?(reader)
    end

    def group_name
      self.group.nil? ? '' : self.group.name
    end
  end

  UserModelExtensions = Proc.new do
    has_and_belongs_to_many :groups
    def designer_or_developer?
      respond_to?(:designer?) ? designer? : developer?
    end
  end
end
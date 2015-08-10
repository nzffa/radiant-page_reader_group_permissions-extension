require_dependency 'page_reader_group_permissions/model_extensions'
require_dependency 'page_reader_group_permissions/controller_extensions'

# Uncomment this if you reference any of your controllers in activate
begin
  require_dependency 'application_controller'
rescue MissingSourceFile
  require_dependency 'application'
end

class PageReaderGroupPermissionsExtension < Radiant::Extension
  version "#{File.read(File.expand_path(File.dirname(__FILE__)) + '/VERSION')}"
  description "Enables you to organize users into groups and apply group-based edit permissions to the page hierarchy."
  url "https://github.com/enspiral/radiant-page_reader_group_permissions-extension"

  def activate
    require 'group'
    raise "A group class should already be defined by the readers extension" unless defined?(Group)

    if Group.table_exists?
      Group.extend(PageReaderGroupPermissions::GroupExtensions)

      User.module_eval &PageReaderGroupPermissions::UserModelExtensions
      Page.module_eval &PageReaderGroupPermissions::PageModelExtensions
      Reader.module_eval &PageReaderGroupPermissions::ReaderModelExtensions
      Admin::PagesController.module_eval &PageReaderGroupPermissions::PageControllerExtensions
      Admin::ReadersController.module_eval &PageReaderGroupPermissions::AdminReadersControllerExtensions
      
      UserActionObserver.instance.send :add_observer!, Group

      Admin::AssetsController.module_eval do
        only_allow_access_to :index, :when => [:admin, :designer]
      end

      if self.respond_to?(:tab)
        admin.page.index.add :node, "page_group_td", :before => "actions_column"
        admin.page.index.add :sitemap_head, "page_group_th", :before => "actions_column_header"
        admin.page.edit.add :form, 'page_group_form_part'
      else
        admin.pages.index.add :node, "page_group_td", :before => "status_column"
        admin.pages.index.add :sitemap_head, "page_group_th", :before => "status_column_header"
        admin.pages.edit.add :parts_bottom, "page_group_form_part", :after => "edit_timestamp"
      end
      
      admin.reader.edit.add :form, 'show_or_create_backend_login', :after => "edit_notes"
    end
  end
end
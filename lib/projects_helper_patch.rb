require_dependency 'projects_helper'

module ProjectsHelperPatch
  def self.included(base)
    base.include(InstanceMethods)
    base.class_eval do
      alias_method_chain :project_settings_tabs, :email_form
    end
  end
  module InstanceMethods
    def project_settings_tabs_with_email_form
      tabs = project_settings_tabs_without_email_form
      tabs<< {:name => 'mail_form',
              :partial => 'projects/mail_from',
              :label => 'field_mail_from'}
      tabs
    end
  end
end

require_dependency 'project'

module ProjectPatch
    def self.included(base) # :nodoc:
        base.send(:extend, ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
          safe_attributes 'mail_from'
        end
    end
    
    module ClassMethods
    end
    
    module InstanceMethods
    end
end

Rails.application.config.to_prepare do
  unless Project.included_modules.include?(ProjectPatch)
    Project.send(:include, ProjectPatch)
  end
end
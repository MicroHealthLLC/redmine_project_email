require_dependency 'projects_controller'

module ProjectControllerPatch
  def self.included(base)
    base.include(InstanceMethods)
    base.class_eval do
      before_filter :authorize, :except => [ :index, :list, :new,
                                             :create, :copy, :archive,:set_mail_form, :unarchive, :destroy]


      def set_mail_form
        @project.mail_from = params[:mail_from]
        @project.save
        redirect_to :back
      end

    end
  end
  module InstanceMethods

  end
end

class ProjectHook < Redmine::Hook::ViewListener
  render_on :view_projects_form, :partial => 'projects/mail_from',
      :layout => false
end
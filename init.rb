require 'redmine'
require 'mailer_patch'
require 'project_patch'

Redmine::Plugin.register :redmine_project_email do
  name 'Redmine Project Email plugin'
  author 'Lawrence McAlpin'
  description 'Adds a per-project email emission address'
  version '0.0.2'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end

Rails.application.config.to_prepare do
  ProjectsHelper.send(:include, ProjectsHelperPatch)
  ProjectsController.send(:include, ProjectControllerPatch)
end

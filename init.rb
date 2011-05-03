require 'redmine'
require 'mailer_patch'
require 'project_patch'
require 'project_hook'

Redmine::Plugin.register :redmine_redmine_project_email do
  name 'Redmine Project Email plugin'
  author 'Lawrence McAlpin'
  description 'Adds a per-project email emission address'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end

require File.dirname(__FILE__) + '/test_helper'
require File.dirname(__FILE__) + '/../init'

class MailerTest < ActiveSupport::TestCase
  include Redmine::I18n
  include ActionController::Assertions::SelectorAssertions
  fixtures :projects, :enabled_modules, :issues, :users, :members, :member_roles, :roles, :documents,
    :attachments, :news, :tokens, :journals, :journal_details, :changesets, :trackers,
    :issue_statuses, :enumerations, :messages, :boards, :repositories, :wiki_contents,
    :wiki_pages, :wikis, :versions
    
  def setup
    ActionMailer::Base.deliveries.clear
    Setting.host_name = 'mydomain.foo'
    Setting.protocol = 'http'
    Setting.default_language = 'en'
  end
  
  def test_issue_add
    issue = Issue.find(1)
    assert Mailer.deliver_issue_add(issue)
    assert 'project1@test.com', last_email.from_addrs[0].address
  end
end

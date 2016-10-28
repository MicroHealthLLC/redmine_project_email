require_dependency 'mailer'

module MailerPatch
    def self.included(base) # :nodoc:
        base.send(:extend, ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
            alias_method_chain :issue_add, :project_emission_email
            # alias_method_chain :mail, :project_emission_email
            alias_method_chain :issue_edit, :project_emission_email
            alias_method_chain :document_added, :project_emission_email
            alias_method_chain :attachments_added, :project_emission_email
            alias_method_chain :news_added, :project_emission_email
            alias_method_chain :message_posted, :project_emission_email
            alias_method_chain :wiki_content_added, :project_emission_email
            alias_method_chain :wiki_content_updated, :project_emission_email

            def mail(headers={}, &block)
              from = @from || Setting.mail_from
              headers.reverse_merge! 'X-Mailer' => 'Redmine',
                                     'X-Redmine-Host' => Setting.host_name,
                                     'X-Redmine-Site' => Setting.app_title,
                                     'X-Auto-Response-Suppress' => 'All',
                                     'Auto-Submitted' => 'auto-generated',
                                     'From' => from,
                                     'List-Id' => "<#{Setting.mail_from.to_s.gsub('@', '.')}>"

              # Replaces users with their email addresses
              [:to, :cc, :bcc].each do |key|
                if headers[key].present?
                  headers[key] = self.class.email_addresses(headers[key])
                end
              end

              # Removes the author from the recipients and cc
              # if the author does not want to receive notifications
              # about what the author do
              if @author && @author.logged? && @author.pref.no_self_notified
                addresses = @author.mails
                headers[:to] -= addresses if headers[:to].is_a?(Array)
                headers[:cc] -= addresses if headers[:cc].is_a?(Array)
              end

              if @author && @author.logged?
                redmine_headers 'Sender' => @author.login
              end

              # Blind carbon copy recipients
              if Setting.bcc_recipients?
                headers[:bcc] = [headers[:to], headers[:cc]].flatten.uniq.reject(&:blank?)
                headers[:to] = nil
                headers[:cc] = nil
              end

              if @message_id_object
                headers[:message_id] = "<#{self.class.message_id_for(@message_id_object)}>"
              end
              if @references_objects
                headers[:references] = @references_objects.collect {|o| "<#{self.class.references_for(o)}>"}.join(' ')
              end

              m = if block_given?
                    super headers, &block
                  else
                    super headers do |format|
                      format.text
                      format.html unless Setting.plain_text_mail?
                    end
                  end
              set_language_if_valid @initial_language

              m
            end
        end
    end
    
    module ClassMethods
    end
    
    module InstanceMethods

      def issue_add_with_project_emission_email(issue, to_users, cc_users)
        from_project issue
        issue_add_without_project_emission_email(issue, to_users, cc_users)
      end

      def issue_edit_with_project_emission_email(journal, to_users, cc_users)
        issue = journal.journalized.reload
        from_project issue
        issue_edit_without_project_emission_email(journal, to_users, cc_users)
      end

      def document_added_with_project_emission_email(document)
        from_project document
        document_added_without_project_emission_email document
      end

      def attachments_added_with_project_emission_email(container)
        container = attachments.first.container
        from_project container
        attachments_added_without_project_emission_email container
      end

      def news_added_with_project_emission_email(news)
        from_project news
        news_added_without_project_emission_email news
      end

      def message_posted_with_project_emission_email(message)
        from_project message
        message_posted_without_project_emission_email message
      end

      def wiki_content_added_with_project_emission_email(wiki_content)
        from_project wiki_content
        wiki_content_added_without_project_emission_email wiki_content
      end

      def wiki_content_updated_with_project_emission_email(wiki_content)
        from_project wiki_content
        wiki_content_updated_without_project_emission_email wiki_content
      end

      def from_project(container)
        if container.present? && container.project.present? && container.project.mail_from.present?
          @from =  container.project.mail_from
        end
      end
    end
end

Rails.application.config.to_prepare do
  unless Mailer.included_modules.include?(MailerPatch)
    Mailer.send(:include, MailerPatch)
  end
end

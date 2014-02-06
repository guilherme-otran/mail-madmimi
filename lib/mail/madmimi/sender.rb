require 'httparty'

module Mail
  module Madmimi
    class Sender
      class MadmimiError < StandardError; end
      attr_accessor :settings

      include ::HTTParty
      base_uri 'https://api.madmimi.com'

      def initialize(settings = {})
        unless settings[:username] && settings[:api_key]
          raise MadmimiError, "Missing username or api_key"
        end

        self.settings = settings
      end

      def deliver!(mail)
        resp = self.class.post '/mailer', body: email_post_body(mail)
        parse_response(resp)
      end

      def parse_response(resp)
        case resp.headers["status"]
          when 200..299 then resp.parsed_response
          else raise MadmimiError.new "status=#{resp.headers["status"]}; " + resp.parsed_response
        end
      end

      def email_post_body(mail)
        settings.merge(
          from:           mail[:from].to_s,
          recipient:      mail[:to].to_s,
          bcc:            mail[:bcc].to_s,
          subject:        mail.subject,
          promotion_name: mail[:promotion_name].to_s,
          raw_html:       html_data(mail).to_s
        )
      end

      def html_data(mail)
        html_data = mail.find_first_mime_type('text/html')

        if html_data
          html_data.body
        else
          mail.mime_type == 'text/html' ? mail.body : nil
        end
      end
    end
  end
end
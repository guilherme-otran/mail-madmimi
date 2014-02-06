mail-madmimi
==============

Integration of Mad Mimi with ActionMailer (Tested Rails 4)

## Gemfile
    gem "mail-madmimi"

## Config
environments/production.rb, and/or development.rb if you want use it

    config.action_mailer.delivery_method = :mad_mimi
    config.action_mailer.mad_mimi_settings = {
      :username => "someuser@example.org",
      :api_key  => "123456789012347890"
    }

You might enable this inside production.rb / development
Remember, the MadMimi API uses HTTP POST requests that may fail

    config.action_mailer.raise_delivery_errors = true

## Mailers

1. Inside the mailer you can put the promotion_name [required for Mad Mimi]:

    mail to: the_email_addresses, promotion_name: 'Promo 1', track_links: false

2. Optional params:
  * subject [String]
    The subject of the email. Will default to the promotion_name if not supplied.
  * bcc
  * check_suppressed [boolean: true or false]
    Checks if the recipient is suppressed and does not send if so (default:off)
    WARNING: This parameter must still be included if the transactional email includes an unsubscribe link.
  * track_links [boolean: true or false]
    Enable or disable link tracking in HTML promotions (default: on).
  * hidden
    Creates the promotion as a hidden promotion so as not to clutter up your web interface (default: off).
  * skip_placeholders [boolean: true or false]
    If you would like Mimi to ignore any {placeholders} you can add this optional parameter (default: false).
  * remove_unsubscribe [boolean: true or false]
    If you created the promotion using custom HTML on the website and would like Mimi to remove the unsubscribe link (default: false).


## Mailer view
And don't forget to place the mimi macros inside the view:

You must include either the [[tracking_beacon]] or [[peek_image]] macro (they are aliases). This is used for tracking opens.

You can also include a [[confirmation_link]] macro in the body of the mail. When it is used, the audience member you’re sending to will be suppressed until they click on the confirmation link in the mail.

---
# That's all you need :)
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

Inside the mailer you can put the promotion_name [required for Mad Mimi]:

    mail to: the_email_addresses, promotion_name: 'Promo 1', track_links: :off

1. Required params
  * to [String]
  * promotion_name [String]
  * view to be rendered [only html format supported]

2. Optional params
  ** Use only :on or :off for boolean params **
  * subject [String]
    The subject of the message, if this is omitted, Action Mailer will ask the Rails I18n class for a translated :subject in the scope of [mailer_scope, action_name] or if this is missing, will translate the humanized version of the action_name
  * bcc [String]
  * check_suppressed [:on or :off]
    Checks if the recipient is suppressed and does not send if so (default: :off)
    WARNING: This parameter must still be included if the transactional email includes an unsubscribe link.
  * track_links [:on or :off]
    Enable or disable link tracking in HTML promotions (default: :on).
  * hidden [:on or :off]
    Creates the promotion as a hidden promotion so as not to clutter up your web interface (default: :off).
  * skip_placeholders [:on or :off]
    If you would like Mimi to ignore any {placeholders} you can add this optional parameter (default: :off).
  * remove_unsubscribe [:on or :off]
    If you created the promotion using custom HTML on the website and would like Mimi to remove the unsubscribe link (default: :off).


## Mailer view
And don't forget to place the mimi macros inside the view:

You must include either the [[tracking_beacon]] or [[peek_image]] macro (they are aliases). This is used for tracking opens.

You can also include a [[confirmation_link]] macro in the body of the mail. When it is used, the audience member you’re sending to will be suppressed until they click on the confirmation link in the mail.

---
# That's all you need :)
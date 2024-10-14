require 'sendgrid-ruby'
require 'dotenv/load'
include SendGrid

def send_verification_email(user)
  corpoDoEmail = "Valide a sua conta no link http://localhost:4567/verify-email?token=#{user.verification_token}"
  from = Email.new(email: 'vitorbatista177@outlook.com')
  to = Email.new(email: user.email)
  subject = 'Assunto do E-mail'
  content = Content.new(type: 'text/plain', value: corpoDoEmail)
  mail = Mail.new(from, subject, to, content)

  sg = SendGrid::API.new(api_key: ENV["API_KEY_SENDGRID"])
  response = sg.client.mail._('send').post(request_body: mail.to_json)
end

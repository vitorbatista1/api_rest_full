

require './models/user'


get '/verify-email' do
  content_type :json
  token = params['token'] 
  user = Users.find_by(verification_token: token)

  if user
    if user.email_verified
      { message: "E-mail já verificado." }.to_json
    else
      user.update(email_verified: true, verification_token: nil)
      { message: "E-mail verificado com sucesso!" }.to_json
    end
  else
    status 404
    { error: "Token inválido ou expirado." }.to_json
  end
end

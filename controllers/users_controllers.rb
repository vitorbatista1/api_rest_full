require 'sinatra'
require 'json'
require 'securerandom'
require './models/user'
require './funcoes/envioEmail'

# Rota para criar um usuário
post '/create-user' do
  content_type :json
  data = JSON.parse(request.body.read)
  first_name = data["nome"]
  last_name = data["sobrenome"]
  email = data["email"]
  password_digest = data["password_digest"]
  
  buscaEmail = Users.find_by(email: email)
  
  if buscaEmail
    status 409
    return { error: "Email já cadastrado" }.to_json
  else
    begin
      verification_token = SecureRandom.hex(10)

      # Criando o usuário
      user = Users.create!(
        first_name: first_name,
        last_name: last_name,
        email: email,
        password_digest: password_digest,
        email_verified: false,
        verification_token: verification_token
      )

      send_verification_email(user)
      status 201
      { message: "Usuário criado com sucesso. Verifique seu e-mail para confirmar" }.to_json
    rescue StandardError => e
      status 422
      { error: "Não foi possível registrar esse usuário, por favor contacte um administrador" }.to_json
    end
  end
end

# Rota para atualizar a senha do usuário
put '/update-user' do
  content_type :json

  begin
    data = JSON.parse(request.body.read)
    emailParaTrocarSenha = data["email"]
    novaPassword = data["pwd3"]

    buscaEmail = Users.find_by(email: emailParaTrocarSenha)
    
    if buscaEmail
      buscaEmail.update!(pwd3: novaPassword)
      status 200
      { message: "Senha atualizada com sucesso" }.to_json
    else
      status 404
      { error: "Não foi possível encontrar o email digitado" }.to_json
    end
  rescue JSON::ParserError
    status 400
    { error: "JSON inválido" }.to_json
  rescue => e
    status 500
    { error: "Erro ao atualizar senha" }.to_json
  end
end

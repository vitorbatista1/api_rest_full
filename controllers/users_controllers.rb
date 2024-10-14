require './models/user'

post '/create-user' do
    content_type :json
    data = JSON.parse(request.body.read)
  
    email = data["email"]
    buscaEmail = Users.find_by(email: email)
    if buscaEmail 
      return { error: "Email ja cadastrado"}.to_json
    else
      begin
        user = Users.create!(nome: data['nome'], email: data['email'], pwd3: data['pwd3'])
        status 201
        user.to_json
      rescue StandardError => e 
        status 422
        { error: e.message }.to_json
      end
    end
  end


  put '/update-user' do
    content_type :json
  
    begin
      data = JSON.parse(request.body.read)
      emailParaTrocarSenha = data["email"]
      novaPassword = data["pwd3"]
        
      buscaEmail = Users.find_by(email: emailParaTrocarSenha)
      if buscaEmail
        buscaEmail.update!(pwd3: novaPassword)
        status 201
        { message: "Senha atualizada com sucesso"}.to_json
      else
        status 404
        { error: "Não foi possível encontrar o email digitado"}.to_json
      end
    rescue JSON::ParserError
      status 400
      { error: "JSON inválido" }.to_json
    rescue => e
      status 500
      { error: "Erro ao atualizar senha" }.to_json
    end
  end
  
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
  
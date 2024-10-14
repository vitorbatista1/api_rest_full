require './models/item'

post '/items' do
    content_type :json
  
    begin
      data = JSON.parse(request.body.read)
      item = Item.create!(nome: data['nome'], descricao: data['descricao'])
      
      status 201
      item.to_json
    rescue StandardError => e
      status 422
      { error: e.message }.to_json
    end
  end
  
  put '/items/:id' do
    begin 
      item = Item.find(params['id'])
      data = JSON.parse(request.body.read)
      item.update!(nome: data['nome'], descricao: data['descricao'])
  
      status 201
      item.to_json
    rescue ActiveRecord::RecordNotFound => e
      status 404
      { error: "Item nao encontrado" }.to_json
    end
  end
  
  delete '/items/:id' do
    begin
      item = Item.find(params['id'])
      item.destroy
      return { message: "#{item.nome} foi removido com sucesso" }.to_json
    rescue ActiveRecord::RecordNotFound => e
      status 404
      { error: "Item não encontrado" }.to_json
    end
  end
  
  get '/all-items' do
    item = Item.all 
    item.to_json
  end
  
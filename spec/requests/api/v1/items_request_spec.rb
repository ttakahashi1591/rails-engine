require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    create_list(:item, 5)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(5)

    items[:data].each do |item|
      expect(items).to have_key(:data)
      expect(items[:data]).to be_an(Array)
      
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end
  end

  it "can get one item by its id" do
    id = create(:item).id
    
    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    
    expect(item).to have_key(:data)
    expect(item[:data]).to be_a(Hash)
    
    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_an(String)

    expect(item[:data]).to have_key(:attributes)
    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes][:description]).to be_a(String)

    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)
  end

  it "can create a new item" do
    merchant = create(:merchant)

    item_params = ({
                    name: 'Cheesecake',
                    description: 'Oreo Cookie',
                    unit_price: 7.5,
                    merchant_id: merchant.id
                  })
    headers = {"CONTENT_TYPE" => "application/json"}
  
    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    
    created_item = Item.last
  
    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
  end

  it "can destroy an item" do
    item = create(:item)
  
    expect(Item.count).to eq(1)
  
    delete "/api/v1/items/#{item.id}"
  
    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "can update an existing item" do
    id = create(:item).id
    previous_name = Item.last.name
    item_params = { name: "Cream Pie" }
    headers = {"CONTENT_TYPE" => "application/json"}
  
    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)
  
    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Cream Pie")
  end

  it "returns a 400 status code when item update fails" do
    item = create(:item)
    item_params = { name: nil } 

    headers = { "CONTENT_TYPE" => "application/json" }
  
    patch "/api/v1/items/#{item.id}", headers: headers, params: JSON.generate({ item: item_params })
  
    expect(response.status).to eq(400) 

    expect(JSON.parse(response.body)["errors"]).to be_present 
  end

  it "provides an items merchants" do
    merchant = create(:merchant)
    item = create(:item, merchant: merchant)
  
    get "/api/v1/merchants/#{merchant.id}/items"
  
    expect(response).to be_successful
  
    merchants = JSON.parse(response.body, symbolize_names: true)
  
    expect(merchants[:data].count).to eq(1)
  
    expect(merchant).to respond_to(:id)
  
    merchants[:data].each do |merchant_data|
      expect(merchant_data).to have_key(:id)
      expect(merchant_data[:id]).to be_an(String)
    end
  end
end
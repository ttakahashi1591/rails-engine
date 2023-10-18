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
    item_params = ({
                    name: 'Cheesecake',
                    description: 'Oreo Cookie',
                    unit_price: 7.5
                  })
    headers = {"CONTENT_TYPE" => "application/json"}
  
    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last
  
    expect(response).to be_successful
    expect(created_item.title).to eq(item_params[:name])
    expect(created_item.author).to eq(item_params[:description])
    expect(created_item.summary).to eq(item_params[:unit_price])
  end
end
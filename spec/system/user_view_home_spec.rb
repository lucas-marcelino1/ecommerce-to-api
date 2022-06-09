require 'rails_helper'

describe 'Usuário acessa a página inicial' do
  it 'e vê galpões' do

    # json_warehouses_data = File.read(Rails.root.join('spec/support/json/warehouses.json'))
    # fake_response = double("faraday_response", status: 200, body: json_warehouses_data)         ////// NÃO É MAIS NECESSÁRIO JÁ QUE O MODEL WAREHOUSES E O MÉTODO .ALL FOI CRIADA
    # allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)
    warehouses = []
    warehouses << Warehouse.new(id: 1, name: 'São Miguel', cod: 'SMB', cep: '89826-500', address: "Rua Bernadino, 540", city: 'Blumenau', description: 'Galpão do seu Bernardo', area: 90_000)
    warehouses << Warehouse.new(id: 2, name: 'Santa Maria', cod: 'SMA', cep: '99826-500', address: "Rua Tunico, 440", city: 'Blumenau', description: 'Galpão do Tunico', area: 7_000)
    allow(Warehouse).to receive(:all).and_return(warehouses)
    visit(root_path)

    expect(page).to have_content("E-commerce App")
    expect(page).to have_content("São Miguel")
    expect(page).to have_content("SMB")
    expect(page).to have_content("Santa Maria")
    expect(page).to have_content("SMA")


  end

  it 'e não existem galpões' do

    fake_response = double("faraday_response", status: 200, body: "[]")

    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)

    visit(root_path)

    expect(page).to have_content("E-commerce App")
    expect(page).to have_content("Nenhum galpão encontrado")
   
  end

  it 'e ve detalhes de um galpão' do

    json_warehouses_data = File.read(Rails.root.join('spec/support/json/warehouses.json'))
    fake_response = double("faraday_response", status: 200, body: json_warehouses_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/warehouses").and_return(fake_response)

    json_warehouse = File.read(Rails.root.join('spec/support/json/warehouse.json'))
    fake_response = double("faraday_response", status: 200, body: json_warehouse)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/warehouses/1").and_return(fake_response)

    visit(root_path)
    click_on('São Miguel')

    expect(current_path).to eq(warehouse_path(1))
    expect(page).to have_content('Detalhes do Galpão São Miguel')
    expect(page).to have_content('São Miguel')
    expect(page).to have_content('Blumenau')
    expect(page).to have_content('Rua Benjamin Constant, 105 - CEP: 89026-200')
    expect(page).to have_content('5000 m²')

  end

  it 'e não é possível carregar o galpão' do

    json_warehouses_data = File.read(Rails.root.join('spec/support/json/warehouses.json'))
    fake_response = double("faraday_response", status: 200, body: json_warehouses_data)
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/warehouses").and_return(fake_response)

    error_response = double("faraday_response", status: 500, body: "{}")
    allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/warehouses/1").and_return(error_response)

    visit(root_path)
    click_on('São Miguel')

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Não foi possível carregar o galpão')
   
  end
end
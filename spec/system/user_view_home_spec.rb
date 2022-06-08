require 'rails_helper'

describe 'Usuário acessa a página inicial' do
  it 'e vê galpões' do

    json_warehouses_data = File.read(Rails.root.join('spec/support/json/warehouses.json'))
    fake_response = double("faraday_response", status: 200, body: json_warehouses_data)

    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)

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
end
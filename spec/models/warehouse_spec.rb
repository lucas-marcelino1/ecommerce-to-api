require 'rails_helper' 


describe Warehouse do
  context '.all' do
    it 'deve conter todos os galpões' do

      json_warehouses_data = File.read(Rails.root.join('spec/support/json/warehouses.json'))
      fake_response = double('faraday_response', status: 200, body: json_warehouses_data)
      allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/warehouses").and_return(fake_response)

      result = Warehouse.all

      expect(result.length).to eq(2)
      expect(result[0].name).to eq('São Miguel')
      expect(result[0].cod).to eq('SMB')
      expect(result[1].name).to eq('Santa Maria')
      expect(result[1].cod).to eq('SMA')

    end

    it 'deve retornar vazio se a API está disponível' do

      fake_response = double('faraday_response', status: 500, body: "{ errors: [não foi possível obter os dados ]}")
      allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/warehouses").and_return(fake_response)
    
      result = Warehouse.all

      expect(result).to eq []
    end
  end
end
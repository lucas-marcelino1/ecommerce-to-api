class Warehouse
  attr_accessor :id, :name, :cod, :cep, :address, :city, :description, :area

  def initialize (id:, name:, cod:, cep:, address:, city:, description:, area:)
    @id = id
    @name = name
    @cod = cod
    @cep = cep
    @address = address
    @city = city
    @description = description
    @area = area
  end

  def self.all
    warehouses = []
    response = Faraday.get('http://localhost:4000/api/v1/warehouses')

    if response.status == 200
      data = JSON.parse(response.body)
      data.each do |d|
        warehouses << Warehouse.new(id: d["id"], name: d["name"], cod: d["cod"], city: d["city"],
                                   cep: d["cep"], address: d["address"], description: d["description"], area: d["area"])
      end
      warehouses
    else
      warehouses
    end

  end

end
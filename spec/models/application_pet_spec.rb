require 'rails_helper'

RSpec.describe ApplicationPet, type: :model do
  describe 'relationships' do
    it {belong_to :application}
    it {belong_to :pet}
    it 'can not have the same pet for the same application' do
      shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      derek = Application.create!(name: "Derek", description: "I love dogs", address: {city: "Denver", state: "CO", street: "Kalamath", zip: 80223 }, status: "Pending")
      pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
      derek.application_pets.create!(pet_id: pet_1.id, application_id: derek.id)

      invalid_pet_application = ApplicationPet.new(pet_id: pet_1.id , application_id: derek.id)
      expect(invalid_pet_application).to_not be_valid
      expect(invalid_pet_application.errors.messages).to include(application_id: ["has already been taken"])
    end
  end
  describe '::class methods' do
    it '::returns approved records' do
      @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
      @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
      @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
      @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
      @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)

      derek = Application.create!(name: "Derek", description: "I love dogs", address: {city: "Denver", state: "CO", street: "Kalamath", zip: 80223 }, status: "Pending")
      jim = Application.create!(name: "Jim", description: "I love dogs", address: {city: "Denver", state: "CO", street: "Kalamath", zip: 80223 }, status: "Pending")

      derek.pets << @pet_1
      jim.pets << @pet_3

      approved = jim.application_pets.update(status: "Approved")



      expect(ApplicationPet.approve).to eq(approved)
    end
  end
end

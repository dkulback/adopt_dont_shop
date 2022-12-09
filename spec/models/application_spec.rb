require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it { validate_presence_of(:city)}
    it { validate_presence_of(:zip)}
    it { validate_presence_of(:street)}
    it { validate_presence_of(:state)}
    it { validate_presence_of(:name)}
    it { validate_presence_of(:description)}

    it { should have_many(:pets).through(:application_pets)}
  end

  describe '::pending' do
    it 'returns only pending applications' do
      derek = Application.create!(name: "Derek", description: "I love dogs", address: {city: "Denver", state: "CO", street: "Kalamath", zip: 80223 }, status: "Pending")
      jim = Application.create!(name: "Derek", description: "I love dogs", address: {city: "Denver", state: "CO", street: "Kalamath", zip: 80223 }, status: "Pending")
      billy = Application.create!(name: "Derek", description: "I love dogs", address: {city: "Denver", state: "CO", street: "Kalamath", zip: 80223 })

      expect(Application.pending).to eq([derek, jim])
    end
  end
  describe '::approved_pets' do
    it 'returns only pets that have been approved on application' do
      shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
      pet_2 = shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      pet_3 = shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
      derek = Application.create!(name: "Derek", description: "I love dogs", address: {city: "Denver", state: "CO", street: "Kalamath", zip: 80223 }, status: "Pending")
      ApplicationPet.create!(pet_id: pet_1.id, application_id: derek.id, status: 'Approved')
      ApplicationPet.create!(pet_id: pet_2.id, application_id: derek.id, status: 'Approved')
      ApplicationPet.create!(pet_id: pet_3.id, application_id: derek.id, status: 'Open')

      expect(derek.approved_pets).to eq([pet_1, pet_2])
    end
  end
  describe '::rejected_pets' do
    it 'returns only pets that have been rejected on application' do
      shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
      pet_2 = shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      pet_3 = shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
      derek = Application.create!(name: "Derek", description: "I love dogs", address: {city: "Denver", state: "CO", street: "Kalamath", zip: 80223 }, status: "Pending")
      ApplicationPet.create!(pet_id: pet_1.id, application_id: derek.id, status: 'Rejected')
      ApplicationPet.create!(pet_id: pet_2.id, application_id: derek.id, status: 'Rejected')
      ApplicationPet.create!(pet_id: pet_3.id, application_id: derek.id, status: 'Open')

      expect(derek.rejected_pets).to eq([pet_1, pet_2])
    end
  end
  describe '::approved_applications?' do
    it 'returns true when there is an approved application' do
      shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
      pet_2 = shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      pet_3 = shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
      derek = Application.create!(name: "Derek", description: "I love dogs", address: {city: "Denver", state: "CO", street: "Kalamath", zip: 80223 }, status: "Pending")
      ApplicationPet.create!(pet_id: pet_1.id, application_id: derek.id, status: 'Rejected')
      ApplicationPet.create!(pet_id: pet_2.id, application_id: derek.id, status: 'Rejected')
      ApplicationPet.create!(pet_id: pet_3.id, application_id: derek.id, status: 'Approved')

      expect(derek.approved_applications?).to eq(true)
    end
  end
  describe '::open_applications?' do
    it 'returns true when there is an open application' do
      shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
      pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
      pet_2 = shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
      pet_3 = shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
      derek = Application.create!(name: "Derek", description: "I love dogs", address: {city: "Denver", state: "CO", street: "Kalamath", zip: 80223 }, status: "Pending")
      ApplicationPet.create!(pet_id: pet_1.id, application_id: derek.id, status: 'Rejected')
      ApplicationPet.create!(pet_id: pet_2.id, application_id: derek.id, status: 'Rejected')
      ApplicationPet.create!(pet_id: pet_3.id, application_id: derek.id, status: 'Open')

      expect(derek.open_applications?).to eq(true)
    end
  end
end

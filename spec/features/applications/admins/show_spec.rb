require 'rails_helper'

RSpec.describe 'admins application show page' do
  it 'it lists every pet that the application is for' do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)

    derek = Application.create!(name: 'Derek', description: 'I love dogs',
                                address: { city: 'Denver', state: 'CO', street: 'Kalamath',
                                           zip: 80_223 }, status: 'Pending')

    derek.pets << @pet_1
    derek.pets << @pet_3
    derek.pets << @pet_4

    visit "/admin/applications/#{derek.id}"

    within '.applicant-pets' do
      expect(page).to have_button('Submit')
      expect(page).to have_content(@pet_1.name)
      expect(page).to have_content(@pet_3.name)
      expect(page).to have_content(@pet_4.name)
      expect(page).to_not have_content(@pet_2.name)
    end
    within ".pet-#{@pet_1.id}" do
      select('Approved', from: :application_pet_status)
      click_button 'Submit'
    end

    expect(page).to have_content("Approved Pets #{@pet_1.name}")
    expect(page).to_not have_css(".pet-#{@pet_1.id}")

    within ".pet-#{@pet_3.id}" do
      select('Approved', from: :application_pet_status)
      click_button 'Submit'
    end

    expect(page).to have_content("Approved Pets #{@pet_3.name}")
  end

  it 'has reject options next to each pet' do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)

    derek = Application.create!(name: 'Derek', description: 'I love dogs',
                                address: { city: 'Denver', state: 'CO', street: 'Kalamath', zip: 80_223 }, status: 'Pending')

    derek.pets << @pet_1
    derek.pets << @pet_3
    derek.pets << @pet_4

    visit "/admin/applications/#{derek.id}"

    within '.applicant-pets' do
      expect(page).to have_button('Submit')
      expect(page).to have_content(@pet_1.name)
      expect(page).to have_content(@pet_3.name)
      expect(page).to have_content(@pet_4.name)
      expect(page).to_not have_content(@pet_2.name)
    end
    within ".pet-#{@pet_1.id}" do
      select('Reject', from: :application_pet_status)
      click_button 'Submit'
    end

    expect(page).to have_content("Rejected Pet #{@pet_1.name}")
    expect(page).to_not have_css(".pet-#{@pet_1.id}")

    within ".pet-#{@pet_3.id}" do
      select('Reject', from: :application_pet_status)
      click_button 'Submit'
    end

    expect(page).to have_content("Rejected Pet #{@pet_3.name}")

    expect(page).to have_css(".pet-#{@pet_4.id}")
  end
  it 'approves one application and rejects others' do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)

    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    derek = Application.create!(name: 'Derek', description: 'I love dogs',
                                address: { city: 'Denver', state: 'CO', street: 'Kalamath', zip: 80_223 }, status: 'Pending')

    jim = Application.create!(name: 'Jim', description: 'I love dogs',
                              address: { city: 'Denver', state: 'CO', street: 'Kalamath', zip: 80_223 }, status: 'Pending')

    derek.pets << @pet_1
    derek.pets << @pet_2
    jim.pets << @pet_1
    jim.pets << @pet_2

    visit "/admin/applications/#{derek.id}"

    within ".pet-#{@pet_1.id}" do
      select('Approved', from: :application_pet_status)
      click_button 'Submit'
    end

    within ".a-#{@pet_1.id}" do
      expect(page).to have_content("Approved Pets #{@pet_1.name}")
    end

    expect(page).to_not have_css(".pet-#{@pet_1.id}")

    within ".pet-#{@pet_2.id}" do
      select('Reject', from: :application_pet_status)
      click_button 'Submit'
    end
    within ".r-#{@pet_2.id}" do
      expect(page).to have_content("Rejected Pet #{@pet_2.name}")
    end

    expect(page).to_not have_css(".pet-#{@pet_2.id}")

    visit "/admin/applications/#{jim.id}"

    expect(page).to have_content("Rejected Pet #{@pet_1.name}")
    expect(page).to_not have_css(".pet-#{@pet_1.id}")
  end

  it 'approves an application once at least 1 pet approved and rest rejected' do
    @shelter_1 = Shelter.create(name: 'Aurora application_pet_status', city: 'Aurora, CO', foster_program: false,
                                rank: 9)
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    derek = Application.create!(name: 'Derek', description: 'I love dogs',
                                address: { city: 'Denver', state: 'CO', street: 'Kalamath', zip: 80_223 }, status: 'Pending')
    derek.pets << @pet_1
    derek.pets << @pet_2

    visit "/admin/applications/#{derek.id}"

    within ".pet-#{@pet_2.id}" do
      select('Approved', from: :application_pet_status)
      click_button 'Submit'
    end

    within ".pet-#{@pet_1.id}" do
      select('Reject', from: :application_pet_status)
      click_button 'Submit'
    end

    expect(page).to have_content('Application Status: Approved')
  end
end

require 'rails_helper'

RSpec.describe 'application show page', type: :feature do
  it 'shows applications attributes' do
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
    pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
    derek = Application.create!(name: 'Derek', description: 'I love dogs',
                                address: { city: 'Denver', state: 'CO', street: 'Kalamath', zip: 80_223 })
    derek.pets << pet_1
    derek.pets << pet_2

    visit "applications/#{derek.id}"

    within '.app' do
      expect(page).to have_content("Applicant name: #{derek.name}")
      expect(page).to have_content("Why they're adopting: #{derek.description}")
      expect(page).to have_content("Application Status: #{derek.status}")
      expect(page).to have_content("Address: #{derek.address['street']} #{derek.address['city']} #{derek.address['state']} #{derek.address['zip']}")
    end
  end

  it 'shows pets attached to applcation' do
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
    pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
    derek = Application.create!(name: 'Derek', description: 'I love dogs',
                                address: { city: 'Denver', state: 'CO', street: 'Kalamath', zip: 80_223 })
    derek.pets << pet_1
    derek.pets << pet_2
    visit "/applications/#{derek.id}"

    within '.pets' do
      expect(page).to have_content(pet_1.name)
      expect(page).to have_content(pet_2.name)

      click_link(pet_1.name)

      expect(current_path).to eq("/pets/#{pet_1.id}")
    end
  end
  it 'has a text box to search results by pet' do
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
    pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
    derek = Application.create!(name: 'Derek', description: 'I love dogs',
                                address: { city: 'Denver', state: 'CO', street: 'Kalamath', zip: 80_223 })

    visit "/applications/#{derek.id}"
    within '.add-pet' do
      expect(page).to have_content('Add a Pet to this Application')
      expect(page).to have_button('Search')
    end
  end

  it 'searches pets on the application show page' do
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
    pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
    derek = Application.create!(name: 'Derek', description: 'I love dogs',
                                address: { city: 'Denver', state: 'CO', street: 'Kalamath', zip: 80_223 })

    visit "/applications/#{derek.id}"

    fill_in 'Search', with: 'Lucille'
    click_on('Search')
    within '.pets-s' do
      expect(page).to have_content(pet_1.name)
    end
  end
  it 'returns partial matches for pet names' do
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create!(adoptable: true, age: 1, breed: 'fluffy', name: 'fluffy', shelter_id: shelter.id)
    pet_2 = Pet.create!(adoptable: true, age: 3, breed: 'fluff', name: 'fluff', shelter_id: shelter.id)
    pet_3 = Pet.create!(adoptable: true, age: 3, breed: 'mr.fluff', name: 'mr.fluff', shelter_id: shelter.id)
    derek = Application.create!(name: 'Derek', description: 'I love dogs',
                                address: { city: 'Denver', state: 'CO', street: 'Kalamath', zip: 80_223 })

    visit "/applications/#{derek.id}"

    fill_in 'Search', with: 'fluf'
    click_on('Search')

    within '.pets-s' do
      expect(page).to have_content(pet_1.name)
      expect(page).to have_content(pet_2.name)
      expect(page).to have_content(pet_3.name)
    end
  end
  it 'has a button that adds a pet to the application' do
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
    pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
    derek = Application.create!(name: 'Derek', description: 'I love dogs',
                                address: { city: 'Denver', state: 'CO', street: 'Kalamath', zip: 80_223 })

    visit "/applications/#{derek.id}"
    fill_in 'Search', with: 'Lucille'
    click_on('Search')

    within ".pets-#{pet_1.id}" do
      click_on('Adopt this Pet')

      expect(current_path).to eq("/applications/#{derek.id}")
    end

    expect(derek.pets).to eq([pet_1])
    within '.pets' do
      expect(page).to have_content(pet_1.name)
    end
  end
  it 'has a button to submit an application' do
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
    pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
    derek = Application.create!(name: 'Derek', description: 'I love dogs',
                                address: { city: 'Denver', state: 'CO', street: 'Kalamath', zip: 80_223 })
    visit "/applications/#{derek.id}"

    expect(page).to have_no_button('Submit Application')
    fill_in 'Search', with: 'Lucille'
    click_on('Search')
    within '.pets-s' do
      click_on('Adopt this Pet')
    end
    within '.submit-app' do
      find('.description', visible: true).set 'I have raised dogs my whole life'
      click_button 'Submit this Application'
    end

    expect(page).to have_content('Status: Pending')
    expect(page).to have_content('Lucille Bald')
    expect(page).to have_no_button('Search')
  end
  it 'wont let you submit an app without pets' do
    shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
    pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)
    derek = Application.create!(name: 'Derek', description: 'I love dogs',
                                address: { city: 'Denver', state: 'CO', street: 'Kalamath', zip: 80_223 })
    visit "/applications/#{derek.id}"

    expect(page).to have_no_button('Submit this Application')
  end
end

require 'rails_helper'
RSpec.describe 'new application from' do
  it 'has a form for an applciant to fill out' do
    visit "/applications/new"

    within ".new-application" do

      fill_in :name, with: 'Derek'
      fill_in :city, with: "Denver"
      fill_in :zip, with: 80332
      fill_in :state, with: "CO"
      fill_in :street, with: "1309 Delaware St"

      click_button 'Submit'
    end

      within '.app' do
        expect(page).to have_content("Applicant name: Derek")
      
        expect(page).to have_content("Application Status: In Progress")
        expect(page).to have_content("Applicant Address: 1309 Delaware St Denver CO 80332")
      end
    end
    it 'returns error messages if form isnt completed' do
      visit "/applications/new"

      within ".new-application" do

        fill_in :name, with: nil
        fill_in :city, with: nil
        fill_in :zip, with: nil
        fill_in :state, with: nil
        fill_in :street, with: nil

        click_button 'Submit'
      end
      within '.error-msgs' do
        expect(page).to have_content("Name can't be blank")
        expect(page).to have_content("Zip can't be blank")
        expect(page).to have_content("Street can't be blank")
      end
    end
  end

class ApplicationPetsController < ApplicationController
  def create
    application = Application.find(params[:id])
    pet = Pet.find(params[:pet_id])
    if !application.pets.include?(pet)
      application.pets << pet
    end
    redirect_to "/applications/#{application.id}"
  end

  def update
    application_pet = ApplicationPet.where("pet_id = ?", params[:pet_id]).distinct
    application_pet.update(status: "Approved")
    
    redirect_to "/admin/applications/#{application_pet[0].application_id}"
  end
end

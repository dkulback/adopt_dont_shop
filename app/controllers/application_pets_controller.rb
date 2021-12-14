class ApplicationPetsController < ApplicationController
  def create
    application = Application.find(params[:id])
    pet = Pet.find(params[:pet_id])
    if !application.pets.include?(pet)
      application.pets << pet
    end
    redirect_to "/applications/#{application.id}"
  end
end

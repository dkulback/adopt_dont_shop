class ApplicationPetsController < ApplicationController
  def create
    application = ApplicationPet.create(pet_id: params[:pet_id], application_id: params[:id])

    redirect_to "/applications/#{application.application_id}"
  end

  def update
    application_pet = ApplicationPet.find(params[:id])
    ApplicationPetService.update(application_pet_params[:status], application_pet)
    redirect_to admin_application_path(application_pet.application_id)
  end

  private

  def application_pet_params
    params.require(:application_pet).permit(:application_id, :pet_id, :status)
  end
end

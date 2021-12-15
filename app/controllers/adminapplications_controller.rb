class AdminapplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @approved_pets = @application.pets.pets_on_app_approved
    @rejected_pets = @application.pets.pets_on_app_rejected
  end

  def update
    # ApplicationPetServiceUpdater.call(params)
    application_pet = ApplicationPet
    .where("pet_id = ?", params[:pet_id])
    .find_by(application_id: params[:id])
    rejected_application_pets = ApplicationPet.
    where("pet_id = ?", params[:pet_id])
    .where.not(application_id: params[:id])
    
    if params[:approved] == "true"
      application_pet.update(status: "Approved")
      rejected_application_pets.update(status: "Rejected")
    elsif params[:rejected] == "true"
      application_pet.update(status: "Rejected")
    end

    redirect_to "/admin/applications/#{application_pet.application_id}"
  end
end

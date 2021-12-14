class AdminapplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @approved_pets = @application.pets.pets_on_app_approved
    @rejected_pets = @application.pets.pets_on_app_rejected
  end

  def update
    application_pet = ApplicationPet.where("pet_id = ?", params[:pet_id]).distinct
    if params[:approved] == "true"
      application_pet.update(status: "Approved")
    elsif params[:rejected] == "true"
      application_pet.update(status: "Rejected")
    end

    redirect_to "/admin/applications/#{application_pet[0].application_id}"
  end
end

class AdminapplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @approved_applications = ApplicationPet.approve
  end
  def update
    application_pet = ApplicationPet.where("pet_id = ?", params[:pet_id]).distinct
    application_pet.update(status: "Approved")

    redirect_to "/admin/applications/#{application_pet[0].application_id}"
  end
end

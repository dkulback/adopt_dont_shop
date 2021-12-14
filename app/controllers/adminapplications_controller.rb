class AdminapplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @approved_applications = ApplicationPet.approve
  end
end

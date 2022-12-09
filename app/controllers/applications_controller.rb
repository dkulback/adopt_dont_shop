class ApplicationsController < ApplicationController

  def index
    @applications = Application.all
  end

  def show
    @applicant = Application.find(params[:id])
    @pets = []
    if params.include?(:search)
      @pets = Pet.search(params[:search])
    end
  end

  def new
    @application = Application.new
  end

  def create
    @application = Application.create(application_params)
    if @application.save
      redirect_to "/applications/#{@application.id}"
    else
      flash.now[:notice] = "Application not created: Required information missing."
      render 'new'
    end
  end

  def update
    application = Application.find(params[:id])
    application.update(description: params[:application][:description],
                      status: "Pending")
    redirect_to "/applications/#{application.id}"

  end

  private
  def application_params
    params.require(:application).permit(:name, :description, :status, address: [:street, :city, :state, :zip])
  end
end

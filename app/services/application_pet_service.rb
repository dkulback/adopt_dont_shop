class ApplicationPetService
  def self.update(status, application)
    if status == 'Approved'
      application.update(status: 'Approved')
      ApplicationPet.find_other_app_pets(application.application_id, application.pet_id).update(status: 'Rejected')
    else
      application.update(status: 'Rejected')
    end
  end
end

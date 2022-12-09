class ApplicationPet < ApplicationRecord
  belongs_to :application
  belongs_to :pet
  validates_uniqueness_of :application_id, scope: :pet_id
  after_update :approve_application

  def self.approve
    where('status = ?', 'Approved')
  end

  def self.open_applications?
    any? do |app|
      app.status == 'Open'
    end
  end

  def self.find_application_pet(app_id, pet_id)
    where(pet_id: pet_id).find_by(application_id: app_id)
  end

  def self.find_other_app_pets(app_id, pet_id)
    where('pet_id = ?', pet_id).where.not(application_id: app_id)
  end

  def approve_application
    application = Application.find(application_id)
    return unless !application.open_applications? && application.approved_applications?

    application.update(status: 'Approved')
  end
end

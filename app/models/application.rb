class Application < ApplicationRecord
  store_accessor :address, :city
  store_accessor :address, :state
  store_accessor :address, :zip
  store_accessor :address, :street
  validates :city, presence: true
  validates :state, presence: true
  validates :zip, presence: true
  validates :street, presence: true
  validates :name, presence: true
  validates :description, presence: true, allow_blank: true, on: :create
  has_many :addresses
  has_many :application_pets
  has_many :pets, through: :application_pets

  def self.pending
    where(status: 'Pending')
  end

  def open_applications
    pets.where('status = ?', 'Open')
  end

  def app_pet(pet_id)
    application_pets.find_by(pet_id: pet_id, application_id: id)
  end

  def approved_pets
    pets.pets_on_app_approved
  end

  def rejected_pets
    pets.pets_on_app_rejected
  end

  def approved_applications?
    application_pets.any? do |app|
      app.status == 'Approved'
    end
  end

  def open_applications?
    application_pets.any? do |app|
      app.status == 'Open'
    end
  end
end

class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true
  belongs_to :shelter
  has_many :application_pets, dependent: :destroy
  has_many :applications, through: :application_pets

  def shelter_name
    shelter.name
  end

  def open_applications?
    application_pets.any? do |application_pet|
      application_pet.status == "Open"
    end
  end

  def self.adoptable
    where(adoptable: true)
  end

  def self.shelters_unique
    Shelter.select(:name).joins(:pets).distinct.pluck(:name)
  end

  def self.pets_on_app_approved
    Pet.joins(:application_pets, :applications).where(application_pets: {status: 'Approved'}).distinct
  end

  def self.pets_on_app_rejected
    Pet.joins(:application_pets, :applications).where(application_pets: {status: 'Rejected'}).distinct
  end
end

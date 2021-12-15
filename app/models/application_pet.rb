class ApplicationPet < ApplicationRecord
  belongs_to :application
  belongs_to :pet
  validates_uniqueness_of :application_id, scope: :pet_id

  def self.approve
    where("status = ?", "Approved")
  end

end

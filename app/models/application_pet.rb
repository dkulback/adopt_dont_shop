class ApplicationPet < ApplicationRecord
  belongs_to :application
  belongs_to :pet

  def self.approve
    where("status = ?", "Approved")
  end
end

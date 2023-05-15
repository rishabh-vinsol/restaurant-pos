class User < ApplicationRecord
  enum role: {
         user: 0,
         admin: 1,
       }

  before_destroy :check_last_admin

  has_secure_password

  validates :first_name, :last_name, :role, :email, presence: true
  validates :email, uniqueness: true

  private def check_last_admin
    return unless admin? && User.where(role: :admin).count == 1

    errors.add(:base, "The last admin cannot be destroyed.")
    throw(:abort)
  end
end

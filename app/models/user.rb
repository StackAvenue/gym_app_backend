class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :email, presence: true
  belongs_to :role
  has_many :user_details
  after_create :update_role

  def update_role
    self.update(role_id: client_role_id)
  end

  def generate_jwt
    JWT.encode(
      { id: id, exp: 60.days.from_now.to_i },
      Rails.application.secrets.secret_key_base
    )
  end

  private

  def client_role_id
    role = Role.find_by_name('client')
    return nil unless role.present?

    role.id
  end
end

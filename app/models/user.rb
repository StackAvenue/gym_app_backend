class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :email, presence: true
  # belongs_to :role
  has_many :users, class_name: 'User', foreign_key: 'trainer_id'
  has_many :user_details, dependent: :destroy
  after_create :update_role

  def update_role
    self.update(role_id: client_role_id)
  end

  def role_name
    return unless role.present?

    role.name
  end

  def generate_jwt
    JWT.encode(
      { id: id, exp: 60.days.from_now.to_i },
      Rails.application.secrets.secret_key_base
    )
  end

  %w[admin client trainer].each do |m|
    define_method :"#{m}?" do
      role.name == m if role.present?
    end
  end

  def user_info
    self.user_details.map do |us|
      us.user_detail_info
    end
  end

  def all_users
    return [] unless admin?

    User.find_each.map do |u|
      u.user_slice_info
    end
  end

  def user_slice_info
    slice('id', 'first_name', 'email').merge('role': role_name, 'created_at': created_date)
  end

  def role
    return unless role_id.present?
    p self
    p role_id
    Role.find(role_id)
  end

  def role_lists
    return [] unless admin?
    Role.find_each.map do |role|
      {role_id: role.id, role_name: role.name }
    end
  end

  def trainer_lists
    return [] unless admin?

    users = User.select(&:trainer?)
    users.map { |user| { trainer_id: user.id, trainer_name: "#{user.first_name} #{user.last_name}" } }
  end

  private

  def client_role_id
    role = Role.find_by_name('client')
    return nil unless role.present?

    role.id
  end

  def created_date
    created_at.strftime('%d %B, %Y %I:%M %p')
  end

end

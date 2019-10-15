class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  validates :email, presence: true
  # belongs_to :role
  belongs_to :trainer, class_name: 'User', foreign_key: 'trainer_id'
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
    slice('id', 'first_name', 'email', 'role_id', 'trainer_id').merge('role': role_name, 'created_at': created_date)
  end

  def role
    return unless role_id.present?
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

  def user_details_response
    { 
      details: user_info, role: role_name,
      all_users: all_users, role_lists: role_lists,
      trainer_lists: trainer_lists, trainer_user_list: trainer_user_list }    
  end

  def trainer_user_list
    return [] unless trainer?
    users.map do |u|
      u.slice('id', 'first_name', 'email').merge('role_name': role_name, 'created_at': created_date, 'trainer_name': trainer_name)
    end
  end
  

  private

  def trainer_name
    trainer_user = trainer
    return unless trainer_user.present?
    "#{trainer_user.first_name} #{trainer_user.last_name}"
  end

  def client_role_id
    role = Role.find_by_name('client')
    return nil unless role.present?

    role.id
  end

  def created_date
    created_at.strftime('%d %B, %Y %I:%M %p')
  end

end

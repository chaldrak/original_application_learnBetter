class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i(google facebook)

  def self.create_unique_string
    SecureRandom.uuid
  end

  def self.find_for_provider(auth)
    user = User.find_by(email: auth.info.email)
    unless user
      user = User.new(email: auth.info.email,
                      provider: auth.provider,
                      uid:      auth.uid,
                      password: Devise.friendly_token[0, 20],
                    )
    end
    user.save
    user
  end
end

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
      user.skip_confirmation!
    end
    user.save
    user
  end

  def self.from_omniauth(auth)

    unless auth.info.email
      auth.info.email = "#{auth.info.name.split(' ').join}@facebook.com"
    end
    
    user = User.where("email= ?", auth.info.email).first
    puts auth.info.picture
    puts auth.info.name
    puts auth.info.email
    if user
      return user
    else
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.name = auth.info.name   # assuming the user model has a name
        # user.image = auth.info.image # assuming the user model has an image
        # If you are using confirmable and the provider(s) you use validate emails, 
        # uncomment the line below to skip the confirmation emails.
        user.skip_confirmation!
        user.uid = user.uid
        user.provider = user.provider
      end
    end
  end
end

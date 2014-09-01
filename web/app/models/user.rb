class User < ActiveRecord::Base
  include PublicActivity::Model
  tracked

  mount_uploader :foto, FotoUploader

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :authentication_keys => [:email]

  devise :omniauthable, :omniauth_providers => [:facebook, :twitter]

#  before_action :set_user, :finish_signup

  validates :email, presence: true
  validates :nombre, presence: true
  #validates :ciudad, presence: true

  #has_many :comment
  has_many :red_socials
  has_many :transaccion_carpools
  
  has_many :user_eventos
  has_many :eventos , through: :user_eventos
  has_many :publicacion_carpools, through: :user_eventos
  has_many :pasajes, through: :user_eventos

  has_many :gustos
  has_many :categories, through: :gustos

  belongs_to :city
  belongs_to :region


  def self.find_for_oauth(auth, signed_in_resource = nil)
    # Get the identity and user if they exist
    identity = RedSocial.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          nombre: auth.extra.raw_info.name,
          #username: auth.info.nickname || auth.uid,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20],
          direccion: auth.info.location
        )
        user.remote_foto_url = auth.info.image.sub("_normal", "").sub("http://","https://") + "?type=large"
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

end

class Request < ApplicationRecord
  attr_accessor :confirmation_token

  validates :name, :phone_number, :paragraph, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
            #this implicitely has uniqueness true
  before_save   :downcase_email
  before_create :create_confirmation_digest

  def accept!
    if confirmed?
      self.accepted = true
      self.accepted_at = DateTime.now
      self.save
    else
      self.errors.add(:confirmed, "The request must be confirmed before being accepted")
    end
  end

  def self.accept_first
    first_in_queue = self.waiting_list.first
    if first_in_queue.nil?
      puts "No one is in the waiting list."
    else
      first_in_queue.accept!
    end
  end

  def self.waiting_list
    self.where(accepted: false, confirmed: true).order(confirmed_at: :asc)
  end

  def self.unconfirmed
    self.where(confirmed: false).order(created_at: :asc)
  end

  def self.accepted
    self.where(accepted: true).order(accepted_at: :asc)
  end

  def self.expired
    self.where(expired: true).order(expired_at: :asc)
  end

  def confirm!
    self.confirmed = true
    self.confirmed_at   = DateTime.now
    self.save
  end

  def sent_confirmation_email
    RequestMailer.account_activation(self).deliver_now
  end

  # Returns a random token
  def Request.new_token
    SecureRandom.urlsafe_base64
  end

  # Returns true if the given token matches the digest
  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Returns the hash digest for a given string.
  def Request.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end


  private
    def downcase_email
      self.email =  self.email.downcase
    end

    #creates assign a digest for the activation of the email
    def create_confirmation_digest
      self.confirmation_token  = Request.new_token
      self.confirmation_digest = Request.digest(confirmation_token)
    end

end



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

  def self.check_waiting_list

    puts "* Runing check_waiting_list *"
    self.look_for_reconfirmation_needed
    self.look_for_expired_requests

  end

  # will check the list for requests that need for reconfirmation
  def self.look_for_reconfirmation_needed

    need_confirmation = Request
                        .waiting_list
                        .where('requests.reconfirmed_at < ?', 1.days.ago)
                        .where(asked_for_reconfirmation: false)

    need_confirmation.each_with_index do |request, index|
      request.prepare_to_reconfirmation_email
      RequestMailer.email_reconfirmation(request, (index+1)).deliver_now
    end

  end

  def prepare_to_reconfirmation_email

      self.asked_for_reconfirmation    = true
      self.asked_for_reconfirmation_at = Time.zone.now
      self.reconfirmed                 = false
      self.create_confirmation_digest
      self.save

  end

  def self.look_for_expired_requests

    expired_requests = self
                       .waiting_list
                       .where(asked_for_reconfirmation: true, reconfirmed: false)
                       .where('requests.asked_for_reconfirmation_at < ? ', 5.days.ago)

    if !expired_requests.blank?
      expired_requests.each do |request|
        request.update!(expired: true, expired_at: Date.today)
      end
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

    self.where(accepted: false, confirmed: true, expired: false).order(confirmed_at: :asc)

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
    self.confirmed_at   = Time.zone.now
    # the first reconfirmed_at date will serve to determine, when to reconfirm again.
    self.reconfirmed_at = Time.zone.now
    self.save

  end

  def reconfirm!

    self.reconfirmed              = true
    self.reconfirmed_at           = Time.zone.now
    self.asked_for_reconfirmation = false
    self.save

  end

  def sent_confirmation_email

    RequestMailer.email_confirmation(self).deliver_now

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

  def downcase_email
    self.email =  self.email.downcase
  end

  #creates assign a digest for the activation of the email
  def create_confirmation_digest

    self.confirmation_token  = Request.new_token
    self.confirmation_digest = Request.digest(confirmation_token)

  end

end



class Request < ApplicationRecord
  attr_accessor :confirmation_token

  validates :name, :phone_number, :paragraph, presence: true

  validates :phone_number, numericality: { only_integer: true }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true, length: { maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
            #this implicitely has uniqueness true

  before_save   :downcase_email
  before_create :create_confirmation_digest

  enum status: { unconfirmed: 0, confirmed: 1,  waiting_reconfirmation: 2,
                 reconfirmed: 3, expired: 4, accepted: 5} do

    event :confirm do

      after do

        self.confirmed_at = Time.zone.now
        # reconfirmed_at will be set at confirmation date,
        # this will serve to determine, when to reconfirm again.
        self.reconfirmed_at = Time.zone.now
        self.save

      end

      transition unconfirmed: :confirmed

    end

    event :ask_for_reconfirmation do

      before do

        self.create_confirmation_digest
        self.asked_for_reconfirmation_at = Time.zone.now
        self.save

      end

      transition [:confirmed, :reconfirmed] => :waiting_reconfirmation

    end

    event :reconfirm! do

      after do
        self.reconfirmed_at = Time.zone.now
        self.save
      end

      transition waiting_reconfirmation: :reconfirmed

    end

    event :expire do

      after do
        self.expired_at = Time.zone.now
        self.save
      end

      transition waiting_reconfirmation: :expired

    end

    event :accept! do

      after do
        self.accepted_at = Time.zone.now
        self.save
      end

      transition [:confirmed, :reconfirmed] => :accepted

    end

  end

  def self.check_waiting_list

    puts "* Running check_waiting_list *"
    self.look_for_reconfirmation_needed
    self.look_for_expired_requests

  end

  # will check the list for requests that need for reconfirmation
  def self.look_for_reconfirmation_needed

    puts "* Running look_for_reconfirmation_needed *"

    need_confirmation = Request.waiting_list
                        .where('requests.reconfirmed_at < ?', 90.days.ago)
    #for testing purposes,  replace the line from above with the line below
    #                    .where('requests.reconfirmed_at < ?', 1.minute.ago)

    need_confirmation.each_with_index do |request, index|

      request.ask_for_reconfirmation
      RequestMailer.email_reconfirmation(request, (index + 1)).deliver_now

    end

  end

  def self.look_for_expired_requests
    puts "* Running look_for_expired_requests *"

    expired_requests = Request
                       .where(status: 2) # where status is waiting_reconfirmation: 2.
                       .where('requests.asked_for_reconfirmation_at < ? ', 5.days.ago)
    #for testing purposes,  replace the line from above with the line below
    #                  .where('requests.asked_for_reconfirmation_at < ? ', 1.minute.ago)


    if !expired_requests.blank?
      expired_requests.each do |request|

        request.expire

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
    # where status is confirmed: 1 or reconfirmed: 3.
    self.where(status: [1,3]).order(confirmed_at: :asc)

  end

  class <<self
     alias_method :confirmed, :waiting_list
  end

  def self.confirmed
    self.waiting_list
  end


  def self.unconfirmed

    # where status is unconfirmed: 0.
    self.where(status: 0).order(created_at: :asc)

  end

  def self.accepted

    #where status is accepted: 5.
    self.where(status: 5).order(accepted_at: :asc)

  end

  def self.expired

    #where status is expired: 4.
    self.where(status: 4).order(expired_at: :desc)

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



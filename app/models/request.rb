class Request < ApplicationRecord
  validates :name, :email, :phone_number, :paragraph, presence: true

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

end



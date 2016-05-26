class Form < ActiveRecord::Base
scope :unverified_phones,  -> { where(phone_verified: false) }

  before_save :set_phone_attributes, if: :phone_verification_needed?
  after_save :send_sms_for_phone_verification, if: :phone_verification_needed?

  def mark_phone_as_verified!
    update!(phone_verified: true, phone_verification_code: nil)
  end

  private

  def set_phone_attributes
    self.phone_verified = false
    self.phone_verification_code = generate_phone_verification_code

    # removes all white spaces, hyphens, and parenthesis
    self.phone_number.gsub!(/[\s\-\(\)]+/, '')
  end

  def send_sms_for_phone_verification
    PhoneVerificationService.new(user_id: id).process
  end

  def generate_phone_verification_code
    begin
     verification_code = SecureRandom.hex(3)
    end while self.class.exists?(phone_verification_code: verification_code)

    verification_code
  end

  def phone_verification_needed?
    phone_number.present? && phone_number_changed?
  end

end

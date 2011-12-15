class User < ActiveRecord::Base
  # Include devise modules
  devise :database_authenticatable, :registerable, :lockable, :recoverable, :trackable, :validatable, :timeoutable
  include Tenacity

  belongs_to :role

  has_many :security_groups, :through => :user_security_groups
  has_many :user_security_groups, :dependent => :destroy

  has_many :memberships, :class_name => "SystemMember", :dependent => :destroy
  has_many :collaborations, :class_name => "SystemMember", :conditions => {:administrator => false}
  has_many :administrations, :class_name => "SystemMember", :conditions => {:administrator => true}

  has_many :system_memberships,
           :through => :memberships,
           :class_name => 'System',
           :source => :system,
           :conditions => {:is_active => true}

  has_many :system_collaborations,
           :through => :collaborations,
           :class_name => 'System',
           :source => :system,
           :conditions => {:is_active => true}

  has_many :system_administrations,
           :through => :administrations,
           :class_name => 'System',
           :source => :system

  t_has_many :raw_files

  # Setup accessible attributes (status/approved flags should NEVER be accessible by mass assignment)
  attr_accessible :email, :password, :password_confirmation, :first_name, :last_name
  attr_readonly :full_name

  validates :first_name, :presence => true, :length => {:maximum => 255}
  validates :last_name, :presence => true, :length => {:maximum => 255}
  validates :status, :presence => true, :length => {:maximum => 255}

  with_options :if => :password_required? do |v|
    v.validates :password, :password_format => true
  end

  before_validation :initialize_status

  #cattr_accessor :current_user

  scope :pending_approval, where(:status => 'U').order(:email)
  scope :approved, where(:status => 'A').order(:email)
  scope :deactivated_or_approved, where("status = 'D' or status = 'A' ").order(:email)
  scope :approved_superusers, joins(:role).merge(User.approved).merge(Role.superuser_roles)

  #TODO: use metasearch
  #TODO: sql injection vector?
  def self.potential_members(name_part)
    escaped_name_part = name_part.gsub('%', '\%').gsub('_', '\_')
    name_start = escaped_name_part + '%'
    name_start.downcase!
    where("status = 'A' and (first_name LIKE ? or last_name LIKE ?)", name_start, name_start).select('first_name, last_name, email, id').order(:first_name, :last_name)
  end


  # Override Devise active for authentication method so that users must be approved before being allowed to log in
  # https://github.com/plataformatec/devise/wiki/How-To:-Require-admin-to-activate-account-before-sign_in
  def active_for_authentication?
    super && approved?
  end

  # Override Devise method so that user is actually notified right after the third failed attempt.
  def attempts_exceeded?
    self.failed_attempts >= self.class.maximum_attempts
  end

  # Overrride Devise method so we can check if account is active before allowing them to get a password reset email
  def send_reset_password_instructions
    if approved?
      generate_reset_password_token!
      ::Devise.mailer.reset_password_instructions(self).deliver
    else
      if pending_approval? or deactivated?
        Notifier.notify_user_that_they_cant_reset_their_password(self).deliver
      end
    end
  end

  # Custom method overriding update_with_password so that we always require a password on the update password action
  # Devise expects the update user and update password to be the same screen so accepts a blank password as indicating that
  # the user doesn't want to change it
  def update_password(params={})
    current_password = params.delete(:current_password)

    result = if valid_password?(current_password)
               update_attributes(params)
             else
               self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
               self.attributes = params
               false
             end

    clean_up_passwords
    result
  end

  # Override devise method that resets a forgotten password, so we can clear locks on reset
  def reset_password!(new_password, new_password_confirmation)
    self.password = new_password
    self.password_confirmation = new_password_confirmation
    clear_reset_password_token if valid?
    if valid?
      unlock_access! if access_locked?
    end
    save
  end


  def approved?
    self.status == 'A'
  end

  def pending_approval?
    self.status == 'U'
  end

  def deactivated?
    self.status == 'D'
  end

  def rejected?
    self.status == 'R'
  end

  def deactivate
    self.status = 'D'
    save!(:validate => false)
  end

  def activate
    self.status = 'A'
    save!(:validate => false)
  end

  def approve_access_request
    self.status = 'A'
    save!(:validate => false)

    # send an email to the user
    Notifier.notify_user_of_approved_request(self).deliver
  end

  def reject_access_request
    self.status = 'R'
    save!(:validate => false)

    # send an email to the user
    Notifier.notify_user_of_rejected_request(self).deliver
  end

  def notify_admin_by_email
    Notifier.notify_superusers_of_access_request(self).deliver
  end

  def check_number_of_superusers(id, current_user_id)
    current_user_id != id.to_i or User.approved_superusers.length >= 2
  end

  def self.get_superuser_emails
    approved_superusers.collect { |u| u.email }
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def name
    full_name
  end

  def is_superuser?
    self.role.name.eql?("manager")
  end

  #Permissions Methods

  def can_read_data_objects
    can_access_data_objects(system_memberships.collect(&:id))
  end

  def can_manage_data_objects
    can_access_data_objects(system_administrations.collect(&:id))
  end

  def can_access_data_objects(systems)
    DataObject.any_in(:system_id => systems).only(:_id).collect(&:_id)
  end


  private

  def initialize_status
    self.status = "U" unless self.status
  end

end

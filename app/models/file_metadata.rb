class FileMetadata
  include Mongoid::Document
  include Mongoid::Timestamps

  field :filename, :type => String
  field :size, :type => String

  embedded_in :raw_file

  before_validation :parse_input

  validates_presence_of :filename, :size
  #validates :required_fields


  protected

  def required_fields
    #TODO
  end

  def parse_input
    #TODO
  end
end

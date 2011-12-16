class FileMetadataSchema
  include Mongoid::Document
  include Mongoid::Timestamps

  field :label,             :type => String
  field :field_type,        :type => String
  field :required,          :type => Boolean

  #Each field will have one or more of these populated
  field :field_value,       :type => Object, :default => nil
    #For fields that only need a single value stored

  field :select_options,    :type => Array, :default => nil
    #Array of hashes. Each has a :value and  a :selected

  field :field_parameters,  :type => Hash, :default => nil
    #Currently, field_paramaters can have the following sets of keys:
    #     |   Key     |  Usage   |
    # (there are actually none yet)

  embedded_in :file_type

  validates_presence_of :label, :field_type
  validates_inclusion_of :field_type, :in => AppConfig.metadata_types.keys

  def collect_select_values
     return nil if self.select_options.blank?

     v = Hash[:values, [], :selected, []]
     index = 0

     unless self.select_options.blank?
       self.select_options.each do |opt|
         option_value = opt['value']
         v[:values] << option_value
         if opt['selected']
           v[:selected] << index
         end
         index+=1
       end
     end
     return v
   end

   #def has_array_of_values?
  #  return type == "Multi"
  #end
  #
  #def has_options?
  #  return type == "Multi" || type == "Select"
  #end
  #
end

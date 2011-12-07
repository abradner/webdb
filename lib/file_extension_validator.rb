class FileExtensionValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless value.blank?
      configuration = {:on => :save}
      configuration.update(options)
      allowed_extensions = [*configuration[:extensions]].map(&:to_s)
      begin
        extension = File.extname(value.file_name)
        if !allowed_extensions.include?(extension)
          record.errors[attribute] << (options[:message] || "is not an accepted type (Valid: #{allowed_extensions})")
        end
      end
    end
  end

end

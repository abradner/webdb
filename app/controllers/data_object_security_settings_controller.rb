class DataObjectSecuritySettingsController < AjaxDataObjectController

  load_resource :data_object_security_group

  def new
    prepare_unselected_sec_group!
  end

  def edit
    prepare_unselected_sec_group!
  end

  def index
    prepare_unselected_sec_group!
     @data_object_security_group = SecurityGroup.new
  end

  def create
    @errors = true unless @data_object.save
  end

  def update
    process_security_group_params!
    params[:data_object][:security_group_ids] = params[:list_selected].split ","
    @errors = true unless @data_object.update_attributes(params[:data_object])
  end

  private
  def process_security_group_params!
    params[:data_object][:security_group_ids] = params[:list_selected].split "," unless params[:data_object][:security_group_ids].blank?
  end
  def prepare_unselected_sec_group!
    @unselected_sec_groups = @system.security_groups - @data_object.security_groups
    unless Rails.env.production?
      output = "Unselected Groups:\n"
      @unselected_sec_groups.each do |u|
        output << u.id << ": " << u.name << "\n"
      end

      output << "Selected Groups:\n"
      @data_object.security_groups.each do |s|
        output << s.id << ": " << s.name << "\n"
      end

      output << "All Groups:\n"
      @system.security_groups.each do |a|
        output << a.id << ": " << a.name << "\n"
      end

      Rails.logger.debug output
    end
  end
end

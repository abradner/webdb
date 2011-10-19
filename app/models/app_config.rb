class AppConfig < Settingslogic
  source "#{Rails.root}/config/webdb_config.yml"
  namespace Rails.env
end

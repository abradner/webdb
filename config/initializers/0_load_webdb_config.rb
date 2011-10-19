APP_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/webdb_config.yml")[Rails.env]
#TODO refactor all uses of APP_CONFIG to SettingsLogic
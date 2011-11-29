#require 'carrierwave/storage/hybrid'

CarrierWave.configure do |config|
  config.grid_fs_database = Mongoid.database.name
  config.grid_fs_host = Mongoid.database.connection.primary_pool.host
  config.grid_fs_access_url = ""
  #config.storage_engines[:hybrid] = "CarrierWave::Storage::Hybrid"
  #config.storage = :hybrid
  #config.move_to_cache = true
  #config.move_to_store = true

end
# Your HTTP server, Apache/etc
role :web, 'staging-hostname'
# This may be the same as your Web server
role :app, 'staging-hostname'
# This is where Rails migrations will run
role :db,  'staging-hostname'


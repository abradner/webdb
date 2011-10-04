# Your HTTP server, Apache/etc
role :web, 'qa-hostname'
# This may be the same as your Web server
role :app, 'qa-hostname'
# This is where Rails migrations will run
role :db,  'qa-hostname'


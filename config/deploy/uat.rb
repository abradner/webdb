# Your HTTP server, Apache/etc
role :web, 'gsw1-archer-uat.intersect.org.au'
# This may be the same as your Web server
role :app, 'gsw1-archer-uat.intersect.org.au'
# This is where Rails migrations will run
role :db,  'gsw1-archer-uat.intersect.org.au', :primary => true


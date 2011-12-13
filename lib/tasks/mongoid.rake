namespace :mongo do

  def confirm(message)
    print "\n#{message}\nAre you sure? [y/n] "
    # STDIN is not supported on heroku :/
    raise 'Aborted' unless STDIN.gets.chomp == 'y'
  end

  desc "gets database"
  task :db => :environment do
    @db = Mongoid.database
  end

  desc "lists collections"
  task :list => ['mongo:db'] do
    @db.collection_names.each { |name| puts name }
  end

  desc "rename collection mongo:rename[from_collection,to_collection]"
  task :rename, :from_col, :to_col, :needs => ['mongo:db'] do |t, args|
    if args[:from_col].nil? or args[:to_col].nil?
      puts "parameters missing, valid format: mongo:rename[from_collection,to_collection]"
      next
    end
    # not supported on heroku
    confirm("Rename collection: #{args[:from_col]} to: #{args[:to_col]}")
    from = @db.collection(args[:from_col])
    from.rename(args[:to_col])
    puts "done"
  end

  desc "drop collection mongo:drop[collection_name]"
   task :drop, :collection, :needs => ['mongo:db'] do |t, args|
    if args[:collection].nil?
      puts "parameters missing, valid format: mongo:drop[collection_name]"
      next
    end
    # not supported on heroku
    confirm("Drop collection: #{args[:collection]}")
    coll = @db.collection(args[:collection])
    coll.drop
    puts "done"
   end

  desc "dumps all collections mongo:dump[path_to]"
  task :dump, :to, :needs => ['mongo:db'] do |t, args|
    auths = @db.connection.auths
    auth = (auths.empty?) ? "" : "--username #{auths[0]['username']} --password #{auths[0]['password']}"
    command = "mongodump --db #{@db.name} --host #{@db.connection.host}:#{@db.connection.port} #{auth} --out #{args[:to]}"
    puts command
    system command
    puts "done"
  end
end
def populate_data

  User.delete_all
  System.delete_all


  create_test_users
end

def create_test_users

  #require 'faster_csv'
  #
  # h = Hash.new(0)
  # FasterCSV.read(AppConfig.sample_users_file)[1..-1].each { |row| h[row[0]] += 1 }
  #
  # user_set = ENV["RAILS_ENV"] || "development"
  # config[user_set]['users'].each do |hash|
  #   next if hash['role'].nil?
  #
  #   role = hash.delete('role')
  #   create_user(hash)
  #   set_role(hash['login'], role)
  # end

  create_user(:email => "shuqian@intersect.org.au", :first_name => "Shuqian", :last_name => "Hon")
  create_user(:email => "alexb@intersect.org.au", :first_name => "Alex", :last_name => "Bradner")
  create_user(:email => "marc@intersect.org.au", :first_name => "Marc", :last_name => "Ziani De Ferranti")
  create_user(:email => "antoni.piotrowski@sydney.edu.au", :first_name => "Antoni", :last_name => "Piotrowski")
  create_user(:email => "khoa.nguyen@sydney.edu.au", :first_name => "Khoa", :last_name => "Nguyen")
  create_unapproved_user(:email => "unapproved1@intersect.org.au", :first_name => "Unapproved", :last_name => "One")
  create_unapproved_user(:email => "unapproved2@intersect.org.au", :first_name => "Unapproved", :last_name => "Two")
  set_role("shuqian@intersect.org.au", "manager")
  set_role("alexb@intersect.org.au", "manager")
  set_role("marc@intersect.org.au", "manager")
  set_role("antoni.piotrowski@sydney.edu.au", "manager")
  set_role("khoa.nguyen@sydney.edu.au", "manager")

end

def set_role(email, role)
  user      = User.where(:email => email).first
  role      = Role.where(:name => role).first
  user.role = role
  user.save!
end

def create_user(attrs)
  u = User.new(attrs.merge(:password => "Pass.123"))
  u.activate
  u.save!
end

def create_unapproved_user(attrs)
  u = User.create!(attrs.merge(:password => "Pass.123"))
  u.save!
end



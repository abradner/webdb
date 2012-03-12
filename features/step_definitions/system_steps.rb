When /^I have sample system (.*)$/ do |name|
  Factory(:system, :name => name)
end

When /^I have systems:$/ do |table|
  table.hashes.each do |hash|
    Factory(:system, hash)
  end
end
When /^user "([^"]*)" can access (.*)$/ do |email, system_name|
  add_user_to_system(email, system_name)
end

When /^user "([^"]*)" can administer (.*)$/ do |email, system_name|
  add_user_to_system(email, system_name, true)
end

def add_user_to_system(email, system_name, admin = false)
  user = User.find_by_email(email)
  system = System.find_by_name(system_name)
  Factory(:system_member, :system => system, :user => user, :administrator => admin)
end
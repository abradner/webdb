When /^system "([^"]*)" has data object (.*)$/ do |sys, name|
  system = System.find_by_name(sys)
  Factory(:data_object, :name => name, :system => system)
end

When /^I have sample data_object (.*)$/ do |name|
  Factory(:data_object, :name => name)
end

When /^I have data objects:$/ do |table|
  table.hashes.each do |hash|
    puts hash.inspect
    if hash.has_key?(:system)
      system_name = hash.delete(:system)
      system = System.find_by_name(system_name)
      Factory(:system, hash.merge!({:system => system}))
    else
      Factory(:system, hash)
    end
  end
end


Then /^I should see file as follows "([^"]*)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end


When /^"([^"]*)" is active$/ do |dobj_name|
  dobj = DataObject.first(:conditions => { :name => dobj_name })
  dobj.is_active = true
  dobj.save!
end
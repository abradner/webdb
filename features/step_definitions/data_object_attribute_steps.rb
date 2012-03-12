When /^data object "([^"]*)" has attributes:$/ do |dobj_name, table|
  table.hashes.each do |hash|
    dobj = DataObject.first(:conditions => { :name => dobj_name })
    Factory(:data_object_attribute, hash.merge!({:data_object => dobj}))
  end
end
Then /^I should see "([^"]*)" table with$/ do |table_id, expected_table|
  actual = find("table##{table_id}").all('tr').map { |row| row.all('th, td').map { |cell| cell.text.strip } }

  chatty_diff_table!(expected_table, actual)
end

Then /^I should see only these rows in "([^"]*)" table$/ do |table_id, expected_table|
  actual = find("table##{table_id}").all('tr').map { |row| row.all('th, td').map { |cell| cell.text.strip } }
  chatty_diff_table!(expected_table, actual, :missing_col => false)
end


Then /^I should see field "([^"]*)" with value "([^"]*)"$/ do |field, value|
  # this assumes you're using the helper to render the field which sets the div id based on the field name
  div_id = field.tr(" ,", "_").downcase
  div_scope = "div#display_#{div_id}"
  with_scope(div_scope) do
    page.should have_content(field)
    page.should have_content(value)
  end
end

Then /^I should see fields displayed$/ do |table|
  # as above, this assumes you're using the helper to render the field which sets the div id based on the field name
  table.hashes.each do |row|
    field = row[:field]
    value = row[:value]
    div_id = field.tr(" ,", "_").downcase
    div_scope = "div#display_#{div_id}"
    with_scope(div_scope) do
      page.should have_content(field)
      page.should have_content(value)
    end
  end
end

Then /^I should see button "([^"]*)"$/ do |arg1|
  page.should have_xpath("//input[@value='#{arg1}']")
end

Then /^I should see image "([^"]*)"$/ do |arg1|
  page.should have_xpath("//img[contains(@src, #{arg1})]")
end

Then /^I should not see button "([^"]*)"$/ do |arg1|
  page.should have_no_xpath("//input[@value='#{arg1}']")
end

Then /^I should see button "([^"]*)" within "([^\"]*)"$/ do |button, scope|
  with_scope(scope) do
    page.should have_xpath("//input[@value='#{button}']")
  end
end

Then /^I should not see button "([^"]*)" within "([^\"]*)"$/ do |button, scope|
  with_scope(scope) do
    page.should have_no_xpath("//input[@value='#{button}']")
  end
end

Then /^I should get a security error "([^"]*)"$/ do |message|
  page.should have_content(message)
  current_path = URI.parse(current_url).path
  current_path.should == path_to("the home page")
end

Then /^I should see link "([^"]*)"$/ do |text|
  page.should have_link(text)
end

Then /^I should not see link "([^"]*)"$/ do |text|
  page.should_not have_link(text)
end

Then /^I should see link "([^\"]*)" within "([^\"]*)"$/ do |text, scope|
  with_scope(scope) do
    page.should have_link(text)
  end
end

Then /^I should not see link "([^\"]*)" within "([^\"]*)"$/ do |text, scope|
  with_scope(scope) do
    page.should_not have_link(text)
  end
end

When /^(?:|I )deselect "([^"]*)" from "([^"]*)"(?: within "([^"]*)")?$/ do |value, field, selector|
  with_scope(selector) do
    unselect(value, :from => field)
  end
end

When /^I select$/ do |table|
  table.hashes.each do |hash|
    When "I select \"#{hash[:value]}\" from \"#{hash[:field]}\""
  end
end

When /^I fill in$/ do |table|
  table.hashes.each do |hash|
    When "I fill in \"#{hash[:field]}\" with \"#{hash[:value]}\""
  end
end

# Sample measurement method table
#      | resource              | name             | field                         | value    |
#      | metabolite            | Metabolite 1     | name                          | Method 1 |
#      | analytical_method     | Analytical 1     | mass_extracted                | 2.0      |
#      | derivatisation_method | Derivatisation 1 | leaf_area_extracted           | 3.34     |
#      | extraction_method     | Extraction 1     | volume_of_extraction_solution | 11       |
#      |                       |                  | volume_derivatised            | 6        |

# Might be buggy!
# For any resource specified in the table, this first searches the database for the given name in the model,
# if not it creates an instance with the specified name

Given /^I have a(?:|n) "([^"]*)" with values$/ do |active_record, table|
  @attr = {}

  table.hashes.each do |hash|

    unless hash[:resource].blank? || hash[:name].blank?
      resource = hash[:resource].downcase.gsub(/\s/, "_")
      @attr[resource.to_sym] = resource.camelize.constantize.where(:name => hash[:name]).first
      @attr[resource.to_sym] ||= Factory(resource.to_sym, :name => hash[:name])
    end

    @attr[hash[:field].downcase.gsub(/\s/, "_").to_sym] = hash[:value] unless hash[:field].blank?
  end
 active_record = Factory(active_record.gsub(/\s/, "_").to_sym, @attr)
end

# can be helpful for @javascript features in lieu of "show me the page
Then /^pause$/ do
  puts "Press Enter to continue"
  STDIN.getc
end

def chatty_diff_table!(expected_table, actual, opts={})
  begin
    expected_table.diff!(actual, opts)
  rescue Cucumber::Ast::Table::Different
    puts "Tables were as follows:"
    puts expected_table
    raise
  end
end

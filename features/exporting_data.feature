Feature: Export data from data objects
  As a user
  I want to export data from data objects
  So I can use it with external programs

  Background:
    Given I have the usual roles and permissions
    And I have sample system MySystem
    And system "MySystem" has data object My Object
    And data object "My Object" has attributes:
      | label       | name   | attribute_type | length | editable | is_id | required | visible |
      | Attribute 1 | attr_1 | string         | 40     | true     | false | false    | true    |
    And data object "My Object" has rows:
      | attr_1 |
      | abc    |
      | def    |
      | ghi    |
    And I am logged in as "super.user@intersect.org.au"

  Scenario: Export entire data object
    Given I am on the data object page for "My Object"
    And I follow "Export"
    And I choose "Everything"
    And I press "Download"
    Then I should see file as follows "blah"
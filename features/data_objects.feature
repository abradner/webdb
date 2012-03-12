Feature: Explore and Manage Data Objects
  As a user
  I want to store, explore and manage my data through data objects
  So I can then extract it in a useful form later

  Background:
    Given I have the usual roles and permissions
    And I have sample system MySystem
    And I am logged in as "super.user@intersect.org.au"
    And user "super.user@intersect.org.au" can access MySystem

  @no-txn
  Scenario: Add record button takes us to new record page
    Given system "MySystem" has data object My Object
    And "My Object" is active
    And data object "My Object" has attributes:
      | label       | name   | attribute_type | length | editable | is_id | required | visible |
      | Attribute 1 | attr_1 | String         | 40     | true     | false | false    | true    |
    And I am on the data object page for My Object
    And I follow "Add Record"
    Then I should be on the add record page for My Object

  Scenario: Add row to data object
    Given system "MySystem" has data object My Object
    And data object "My Object" has attributes:
      | label       | name   | attribute_type | length | editable | is_id | required | visible |
      | Attribute 1 | attr_2 | String         | 40     | true     | false | false    | true    |
    And I am on the data object page for My Object
    And I follow "Add Record"
    And I fill in the following:
      | Attribute 1 | abc |
    And I press "Create Data object row"
    Then I should be on the data object page for My Object
    And I should see "data_object_contents" table with
      | Attribute 1 |
      | abc         |


Feature: Approve access requests
  In order to allow users to access the system
  As an administrator
  I want to approve access requests

  Background:
    Given I have roles
      | name       |
      | manager    |
      | Researcher |
    And I have permissions
      | entity | action  | roles   |
      | User   | read    | manager |
      | User   | admin   | manager |
      | User   | reject  | manager |
      | User   | approve | manager |
    And I have a user "super.user@intersect.org.au" with role "manager"
    And I have access requests
      | email                  | first_name | last_name |
      | user1@intersect.org.au | User       | One       |
      | user2@intersect.org.au | User       | Two       |
    And I am logged in as "super.user@intersect.org.au"

  Scenario: View a list of access requests
    Given I am on the access requests page
    Then I should see "access_requests" table with
      | First name | Last name | Email                  |
      | User       | One       | user1@intersect.org.au |
      | User       | Two       | user2@intersect.org.au |

  Scenario: Approve an access request from the list page
    Given I am on the access requests page
    When I follow "Approve" for "user2@intersect.org.au"
    And I select "manager" from "role"
    And I press "Approve"
    Then I should see "The access request for user2@intersect.org.au was approved."
    And I should see "access_requests" table with
      | First name | Last name | Email                  |
      | User       | One       | user1@intersect.org.au |
    And "user2@intersect.org.au" should receive an email with subject "WebDB - Your access request has been approved"
    When they open the email
    Then they should see "You made a request for access to the WebDB System. Your request has been approved. Please visit" in the email body
    And they should see "Hello User Two," in the email body
    When they click the first link in the email
    Then I should be on the home page

  Scenario: Cancel out of approving an access request from the list page
    Given I am on the access requests page
    When I follow "Approve" for "user2@intersect.org.au"
    And I select "manager" from "role"
    And I follow "Back"
    Then I should be on the access requests page
    And I should see "access_requests" table with
      | First name | Last name | Email                  |
      | User       | One       | user1@intersect.org.au |
      | User       | Two       | user2@intersect.org.au |

  Scenario: View details of an access request
    Given I am on the access requests page
    When I follow "View Details" for "user2@intersect.org.au"
    Then I should see "user2@intersect.org.au"
    Then I should see field "Email" with value "user2@intersect.org.au"
    Then I should see field "First name" with value "User"
    Then I should see field "Last name" with value "Two"
    Then I should see field "Role" with value ""
    Then I should see field "Status" with value "Pending Approval"

  Scenario: Approve an access request from the view details page
    Given I am on the access requests page
    When I follow "View Details" for "user2@intersect.org.au"
    And I follow "Approve"
    And I select "manager" from "role"
    And I press "Approve"
    Then I should see "The access request for user2@intersect.org.au was approved."
    And I should see "access_requests" table with
      | First name | Last name | Email                  |
      | User       | One       | user1@intersect.org.au |

  Scenario: Cancel out of approving an access request from the view details page
    Given I am on the access requests page
    When I follow "View Details" for "user2@intersect.org.au"
    And I follow "Approve"
    And I select "manager" from "role"
    And I follow "Back"
    Then I should be on the access requests page
    And I should see "access_requests" table with
      | First name | Last name | Email                  |
      | User       | One       | user1@intersect.org.au |
      | User       | Two       | user2@intersect.org.au |

  Scenario: Go back to the access requests page from the view details page without doing anything
    Given I am on the access requests page
    And I follow "View Details" for "user2@intersect.org.au"
    When I follow "Back"
    Then I should be on the access requests page
    And I should see "access_requests" table with
      | First name | Last name | Email                  |
      | User       | One       | user1@intersect.org.au |
      | User       | Two       | user2@intersect.org.au |

  Scenario: Role should be mandatory when approving an access request
    Given I am on the access requests page
    When I follow "Approve" for "user2@intersect.org.au"
    And I press "Approve"
    Then I should see "Please select a role for the user."

  Scenario: Approved user should be able to log in
    Given I am on the access requests page
    When I follow "Approve" for "user2@intersect.org.au"
    And I select "manager" from "role"
    And I press "Approve"
    And I am on the home page
    And I follow "Logout"
    Then I should be able to log in with "user2@intersect.org.au" and "Pas$w0rd"

  Scenario: Approved user roles should be correctly saved
    Given I am on the access requests page
    And I follow "Approve" for "user2@intersect.org.au"
    And I select "manager" from "role"
    And I press "Approve"
    And I am on the list users page
    When I follow "View Details" for "user2@intersect.org.au"
    And I should see field "Role" with value "manager"

# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :colour_scheme do
      sequence(:name) {|n| "Colour Scheme #{n}"}
      banner "000000"
      background "111111"
      body "222222"
      h1 "333333"
      h2 "444444"
      h3 "555555"
      a "666666"
      a_visited "777777"
      a_active "888888"
      a_hover "999999"
    end
end
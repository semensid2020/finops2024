class UserAccountDecorator < ApplicationDecorator
  decorates_association :owner
  delegate_all
end

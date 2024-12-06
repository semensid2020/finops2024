class OperationDecorator < ApplicationDecorator
  decorates_association :sender
  decorates_association :recipient
  delegate_all
end

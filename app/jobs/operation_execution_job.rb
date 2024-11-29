class OperationExecutionJob < ApplicationJob
  queue_as :operations

  def perform(operation)
    OperationExecutionService.call(operation)
  end
end

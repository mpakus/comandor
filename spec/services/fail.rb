# frozen_string_literal: true

class ServiceFail
  extend Comandor

  def perform
    error(:name, :blank)
    error(:name, :nil)
    error(:age, :blank)
  end
end

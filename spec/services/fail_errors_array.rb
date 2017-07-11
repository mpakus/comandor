# frozen_string_literal: true

class ServiceFailErrorsArray
  extend Comandor

  def perform
    error(:name, %i[blank nil])
    error(:age, :blank)
  end
end

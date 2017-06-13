# frozen_string_literal: true

class ServiceParams
  extend Comandor

  def perform(name, age)
    "#{name} #{age}"
  end
end

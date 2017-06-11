
# frozen_string_literal: true

class ServiceSuccess
  extend Comandor

  def initialize(name, age)
    @name = name
    @age = age
  end

  def perform
    "#{@name} #{@age}"
  end
end

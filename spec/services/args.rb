# frozen_string_literal: true

class ServiceArgs
  extend Comandor

  def perform(name, user)
    age = user.fetch(:age)
    age = yield(age) if block_given?
    "#{name} #{age}"
  end
end

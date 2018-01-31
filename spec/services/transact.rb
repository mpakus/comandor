# frozen_string_literal: true

class MyBasic
  def self.transaction
    res = ''
    res = yield if block_given?
    "[ #{res} ]"
  end
end

class ServiceTransact
  extend Comandor
  transaction! 'MyBasic.transaction'

  def perform(second, first)
    "#{first} #{second}"
  end
end

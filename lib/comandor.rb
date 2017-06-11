# frozen_string_literal: true

require 'comandor/version'

# Service Objects
module Comandor
  attr_reader :result

  # Callback on `extend Comandor`
  def self.extended(base)
    base.prepend(self)
  end

  # @return [self]
  def perform
    raise NoMethodError unless defined?(:perform)
    @result = super
    @done = true
    self
  end

  # Add new error to key array
  # @param key [Symbol]
  # @param message [String]
  # @return [self]
  def error(key, message)
    errors[key] ||= []
    errors[key] << message
    self
  end

  # Are we done here?
  # @return [Boolean]
  def success?
    done? && !errors?
  end

  # Are we failed?
  # @return [Boolean]
  def fail?
    done? && errors?
  end
  alias failed? fail?

  # List of errors
  # @return [Hash<Symbol => Array>]
  def errors
    @errors ||= {}
  end

  private

  def done?
    @done ||= false
  end

  def errors?
    errors.any?
  end
end

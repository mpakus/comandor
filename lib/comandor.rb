# frozen_string_literal: true

require 'comandor/version'

# Service Objects
module Comandor
  attr_reader :result

  # Callback on `extend Comandor`
  def self.extended(base)
    base.prepend(self)
    base.extend(ClassMethods)
  end

  # ClassName.perform
  module ClassMethods
    # Callback when inherited from Comandor class
    def inherited(child)
      child.prepend(Comandor)
      child.extend(ClassMethods)
    end

    def perform(*args, &block)
      new.perform(*args, &block)
    end

    # Add transaction layer
    # @param [name] [String] ActiveRecord::Base.transaction
    def transaction!(name)
      class_eval { @transaction_klass, @transaction_method = name.split('.') }
    end

    # Class variables accessor
    def transaction_klass
      @transaction_klass
    end

    def transaction_method
      @transaction_method
    end
  end

  # @return [self]
  def perform(*args, &block)
    raise NoMethodError unless defined?(:perform)
    @result = if self.class.transaction_klass && self.class.transaction_method
                Object.const_get(self.class.transaction_klass).send self.class.transaction_method.to_sym do
                  super
                end
              else
                super
              end
    @done = true
    self
  end

  # Add new error to key array
  # @param key [Symbol]
  # @param message [String]
  # @return [False]
  def error(key, message)
    errors[key] ||= []
    if message.is_a? Array
      errors[key] = errors[key] + message
    else
      errors[key] << message
    end
    false
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

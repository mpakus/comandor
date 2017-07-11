# Comandor

[![CircleCI](https://circleci.com/gh/mpakus/comandor.svg?style=svg)](https://circleci.com/gh/mpakus/comandor)

Service Object (Interactor, Command) are used to encapsulate your application's business logic. 
To keep Singe Responsibility principle each service object represents only one thing that your application does.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'comandor'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install comandor

## Usage

```ruby

# Your Service class
class DepositCreate
  extend Comandor # here we are!

  # Initialize object with some arguments as usual Ruby object (of course it's optional)
  def initialize(user, amount)
    @user = user
    @amount = amount
  end

  # Define your business logic by implementing the #perform method.
  # Results of call will be in the #result method of instance.
  # #perform will return the instance of your Class.
  # You can use the #success? method to check if results it is a valid
  # or fail? (failed?) if it’s invalid.
  # And you can get all errors with #errors method.
  def perform
    # .error method adds message to the :amount field
    return error(:amount, 'Deposit amount should be more than $100') if @amount < 100
    create_deposit
  end
  
  private
  
  def create_deposit
    @user.deposits.create(amount: @amount)
  end
end
```

In the Controller:

```ruby
class DepositsController < ApplicationController
  def create
    deposit_create = DepositCreate.new(current_user, 100).perform
    if deposit_create.success?
      redirect_to root_path, notice: 'Deposit created'
    else
      redirect_to root_path, alert: deposit_create.errors[:amount].join("\n")
    end
  end
end
```

Another option to call #perform with any arguments

```ruby
# Another Service class
class InvoiceSend
  extend Comandor # here we are!
  
  def perform(email = nil, amount = 0)
    return error(:amount, 'Deposit amount should be more than $100') if amount < 100
    return error(:email, 'E-mail is blank') unless email
    create_and_send_invoice(email, amount)
  end
  
  private
  
  def create_and_send_invoice(email, amount)
    # ... your another code is here    
  end    
end
```

in use:
```ruby
delivery = InvoiceSend.new.perform('renat@aomega.co', 100)
if delivery.success?
  # all good
  puts delivery.result
else
  # Houston, we have a problem 
  puts deliver.errors.inspect  
end
```

state methods:
```ruby
# was last .perform call success or not
delivery.success?

# results of .perform call
delivery.result

# Hash of errors
#{
#  'field1': ['error message 1', 'error message 2'],
#  'field2': ['error message 3']
#}
delivery.errors
```

one more example:
```ruby
class User::Registration
  attr_reader :user, :bank_account
  extend Comandor
    
  def initialize(params)
    @params = params
  end
  
  def perform
    create_user! && create_bank_account!
  end
  
  private
  
  def create_user!
    @user = User.new(@params)
    return true if @user.save
    error(:user, @user.errors.to_a)
    false
  end
  
  def create_bank_account!
    @bank_account = Bank::Account.new(user: @user)
    return true if @bank_account.save
    error(:bank_account, @bank_account.errors.to_a)
    false
  end
end
```

example of using:
```ruby
  registration = User::Registration.new(user_params).perform
  if registration.success?
    puts registration.user.inspect
    puts registration.bank_account.inspect
  else
    puts registration.errors  
  end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mpakus/comandor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

# Comandor

Service Object are used to encapsulate your application's business logic. 
In single-purpose (Singe Responsibility principle) each service object represents one thing that your application does.

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

# Service class
class DepositCreate
  extend Comandor

  # initialize object with some arguments as usual Ruby object (optional)
  def initialize(user, amount)
    @user = user
    @amount = user
  end

  # then you have to define: #perform method 
  # and result of call will be in the #result instance variable
  def perform
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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mpakus/comandor. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


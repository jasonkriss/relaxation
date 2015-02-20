# Relaxation

Restful API controllers with less code.

## Installation

Add this line to your application's Gemfile:

    gem 'relaxation'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install relaxation

## Usage

The following controller will generate actions for `show`, `create`, `update`, and `destroy`. Only the `name` attribute will be allowed on update while `name` and `file` attributes are allowed on creation.

```ruby
class ItemsController < ApplicationController
  creatable :name, :file
  updatable :name
  relax except: :index
end
```

If you need to paginate the `index` action, simply override the `render_list` method:

```ruby
class ApplicationController < ActionController::API
  def render_list(list)
    render_paginated(list)
  end
end
```

## Contributing

1. Fork it ( http://github.com/jasonkriss/relaxation/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

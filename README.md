#CoffeeKup Rails
CoffeeKup Rails is an asset pipeline engine/preprocessor for [coffeekup](http://coffeekup.org/) template files.
Simply place your coffeekup templates in a configured asset directory with a .js.ck extension and they will be automatically available as precompiled js templates.
##Example
Say your client side views live in `/app/assets/javascripts/views` (default).

Given `/app/assets/javascripts/views/shared/hello.js.ck`:

    h1 "Hello #{@name}."

CoffeeKup will automatically compile the coffeescript source to a coffeekup javascript template under a desired 
global js object (defaults to `window.templates`). Template names are period delimited by directory structure:

From the javascript console:

    templates['shared.hello']({name: 'chris'})
    => "<h1>Hello chris.</h1>"

This happens upon every page load when your .ck files change thanks to sprockets and the asset pipeline just as you would expect for a .coffee file.

## Installation
  1. First grab [node.js](http://nodejs.org/#download) and [npm](https://github.com/isaacs/npm)
  2. `npm install coffeekup -g`
  3. `gem 'coffeekup_rails', :git => "git://github.com/chrismccord/coffeekup_rails.git"` and `bundle`

Will be pushed to rubygems soon.

### Initializer
Configuration optional (defaults are redundantly set here); however, `Coffeekup.register_engine` must be included.

    app/config/initializers/coffeekup.rb:
    
    Coffeekup.configure do |config|
      config.namespace = 'templates'
      config.extension = 'ck'
    end

    Coffeekup.register_engine

## Configuration
    Coffeekup.configure do |config|
      config.namespace = 'name_of_global_js_object'  # default 'templates'
      config.extension = 'coffeekup'                 # default 'ck'
    end

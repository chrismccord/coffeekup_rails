module Coffeekup
  module Configuration

    # Global frontend object name holding the templates
    DEFAULT_NAMESPACE = 'templates'
    # Base view directory where .ck templates will live
    DEFAULT_BASE_DIRECTORY = "app/assets/javascripts/views"
    # Extensions to use for Coffeekup files
    DEFAULT_EXTENSION = "ck"

    attr_accessor :namespace,
                  :base_directory,
                  :extension,
                  :files
    
    # set all configuration options to their default values
    def self.extended(base)
      base.reset
    end
    
    def configure
      yield self
    end
    
    def reset
      self.namespace         = DEFAULT_NAMESPACE
      self.base_directory    = DEFAULT_BASE_DIRECTORY
      self.extension         = DEFAULT_EXTENSION
    end
  end
end
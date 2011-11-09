require "coffeekup/version"
require "coffeekup/errors"
require "coffeekup/configuration"
require 'open3'
require 'tilt'
require 'fileutils'

module Coffeekup
  extend Configuration

  def self.register_engine
    Rails.application.assets.register_engine ".#{self.extension}", Coffeekup::Template
  end

  # Execute coffeekup command, compile source, and capture errors
  #  params:
  #    source           input file path
  #    options
  #      namespace      optional js template namespace to use instead of default
  #  
  #  returns:
  #    contents of compiled file
  #
  def self.compile!(source, options = {})
    nspace = options[:namespace] || self.namespace
    base_dir = self.base_directory
    base_dir += "/" if base_dir[-1] != "/" 
    filename = source.split(base_dir).last.gsub("/", ".").gsub('.js', '')
    @files = {
      :tmp => "#{Rails.root}/tmp/#{filename}",
      :compiled_tmp => "#{Rails.root}/tmp/#{filename}".gsub(self.extension, 'js')
    }
    FileUtils.cp(source, @files[:tmp])
    i, o, stderr = Open3.popen3("coffeekup --js -f --namespace '#{nspace}' '#{@files[:tmp]}'")
    errors = stderr.read
    raise CompilationError, "#{source}\n\n#{errors}" if not errors.blank?
    
    File.open(@files[:compiled_tmp]).read      
  end

  
  def self.cleanup
    @files.each{|f| File.delete(f[1]) rescue nil }
  end
  
  class Template < Tilt::Template

    def prepare    
    end

    def evaluate(context, locals, &block)
      # Takes coffeescript coffeekup file (.js.ck) and converts into compiled js
      # templates loaded into window.templates object, IE:
      #   /app/assets/javascripts/views/shared/index.js.ck => templates['shared.index']()
      begin
        compiled_output = Coffeekup.compile!(@file)
      ensure
        Coffeekup.cleanup
      end

      compiled_output
    end
  end
end


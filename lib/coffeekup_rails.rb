require "coffeekup/version"
require "coffeekup/errors"
require "coffeekup/configuration"
require 'open3'
require 'tilt'

module Coffeekup
  extend Configuration

  class Template < Tilt::Template
    
    def prepare
    end

    def evaluate(context, locals, &block)
      # Takes coffeescript coffeekup file (.js.ck) and converts into compiled js
      # templates loaded into window.templates object, IE:
      #   /app/assets/javascripts/views/shared/index.js.ck => templates['shared.index']()

      base_dir = Coffeekup.base_directory
      base_dir += "/" if base_dir[-1] != "/" 
      namespace = Coffeekup.namespace
      
      filename = file.split(base_dir).last.gsub("/", ".").gsub('.js', '')
      tmp_file = "#{Rails.root}/tmp/#{filename}"
      compiled_tmp_file = tmp_file.gsub(Coffeekup.extension, 'js')
      file_contents = File.open(file).read
      File.open(tmp_file, "w"){|f| f.puts file_contents }
      command = "coffeekup --js -f --namespace '#{namespace}' '#{tmp_file}'"
      stdin, stdout, stderr = Open3.popen3(command)
      errors = stderr.read
      
      if not errors.blank?
        File.delete(tmp_file)
        raise CompilationError, "#{file}\n\n#{errors.to_s}"
      end
      out = File.open(compiled_tmp_file).read
      File.delete(tmp_file)
      File.delete(compiled_tmp_file)
      
      out
    end
  end
  
  def self.register_engine
    Rails.application.assets.register_engine ".#{self.extension}", Coffeekup::Template
  end
end


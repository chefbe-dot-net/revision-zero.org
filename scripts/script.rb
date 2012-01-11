Dir.chdir File.expand_path("../../", __FILE__)
$LOAD_PATH.unshift "lib"
require 'bundler/setup'
require 'epath'
require 'quickl'
require 'logger'

module Script
  
  attr_accessor :enable_logging
  
  def root
    Path File.expand_path("../../", __FILE__)
  end
  
  def logger
    @logger ||= Logger.new(root/:logs/"#{Quickl.command_name(self)}.log") if enable_logging
  end
  
  def log(message, severity)
    puts message
    logger.send(severity, message) if enable_logging
    yield if block_given?
  end
  def debug(message, &block); log(message, :debug, &block); end
  def info(message, &block);  log(message, :info,  &block); end
  def warn(message, &block);  log(message, :warn,  &block); end
  def error(message, &block); log(message, :error, &block); end
  def fatal(message, &block); log(message, :fatal, &block); end
  
end

def Script(*args) 
  Quickl::Command(*args) do |builder|
    builder.instance_module Script
  end
end

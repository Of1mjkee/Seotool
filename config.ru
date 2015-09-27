require 'rubygems'
require 'bundler'

Bundler.require

storage_config = YAML.load(File.read(File.join(File.dirname(__FILE__), 'lib/configure/storage_config.yml')))

#SEO ANALYZER IMPORT
require File.expand_path('../lib/api/analyzer', __FILE__)
require File.expand_path('../lib/api/report_object', __FILE__)

#STORAGE IMPORT
require File.expand_path('../lib/storage/interface_storage', __FILE__)
require File.expand_path('../lib/storage/fs_storage', __FILE__)
require File.expand_path('../lib/storage/db_storage', __FILE__)
require File.expand_path('../lib/storage/ormdm_storage',__FILE__)

#MAPPING OBJECTS
require File.expand_path('../lib/models/dm_mappings.rb',__FILE__)

#APP
require File.expand_path('../application', __FILE__)

run Application.new

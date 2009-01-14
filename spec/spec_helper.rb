# Slurp in the full Rails stack
# Takes some time but makes it easier to write the tests..
RAILS_ENV = "test"
require File.dirname(__FILE__) + '/../../../../config/environment.rb'
require 'spec/rails'


# Of course we don't want to create a database and such so we're mocking out AR
# Also see http://blog.s21g.com/articles/472
class MockBase < ActiveRecord::Base; end
MockBase.class_eval do
  alias_method :save, :valid?
  def self.columns() @columns ||= []; end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type, null)
  end
end
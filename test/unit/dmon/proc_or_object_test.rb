# Copyright (c) 2011 Ketan Padegaonkar.
# Licenced under the MIT License (http://www.opensource.org/licenses/mit-license.php)

require "rubygems"
gem "test-unit"

require "test/unit"
require 'dmon'

module Dmon
class ProcOrObjectTest < Test::Unit::TestCase
  
  class Foo
    include ProcOrObject
    proc_or_object :some_property
  end
  
  test "should return result of proc when accessing property" do
    f = Foo.new
    f.some_property = proc {'foo'}
    assert_equal 'foo', f.some_property
  end
  
end
end
require 'test_helper'
require 'memoist'

class SubclassBugTest < Test::Unit::TestCase
  class Person
    extend Memoist

    attr_reader :name_calls

    def initialize
      @name_calls = 0
    end

    def name
      @name_calls += 1
      "Person"
    end

    memoize :name
  end

  class Student < Person
    attr_reader :name_calls
    def initialize
      @name_calls = 0
    end

    def name
      @name_calls += 1
      "Student"
    end
  end

  def setup
    @person = Person.new
    @student = Student.new
  end

  def test_memoization_subclass
    assert_equal "Student", @student.name
    assert_equal 1, @student.name_calls

    3.times { assert_equal "Student", @student.name }
    assert_equal 1, @student.name_calls
    assert @student.name.equal?(@person.name)
  end

end

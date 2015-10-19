require 'test_helper'
=begin
class ProgramTest < ActiveSupport::TestCase

#Testing save operation on model of program
  def test_save_name_nil
  	program = Program.new(:name => programs(:name_nil).name)

  	assert_not program.valid?
  	assert_not program.save
  end

  def test_save_correct
  	program = Program.new(:name => programs(:correct).name)

  	assert program.valid?
  	assert program.save
  end
end
=end

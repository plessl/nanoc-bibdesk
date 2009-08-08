require 'text-helpers'
require 'test/unit'

class TestTextHelpers < Test::Unit::TestCase

  def test_joined_by_comma_and_and__one_author
    a = ['C. Plessl']
    assert_equal('C. Plessl', a.joined_by_comma_and_and)
  end
  
  def test_joined_by_comma_and_and__two_authors
    a = ['C. Plessl', 'M. Grad']
    assert_equal('C. Plessl and M. Grad', a.joined_by_comma_and_and)
  end

  def test_joined_by_comma_and_and__three_authors
    a = ['C. Plessl', 'M. Grad', 'M. Platzner']
    assert_equal('C. Plessl, M. Grad and M. Platzner', a.joined_by_comma_and_and)
  end

  def test_detex_endash
    i = "--"
    o = "–"
  end
  
  def test_detex_emdash
    
  end
  
  
end
class Array

  def joined_by_comma_and_and
    head = self[0..-2]
    tail = self[-1]
    if self.size > 1
      return head.join(', ') + " and " + tail.to_s
    else
      return self.to_s
    end
  end

end

class String
  
  def detex
    return self
  end


  # implementation taken from http://github.com/samsouder/titlecase
  def titlecase
    small_words = %w(a an and as at but by en for if in of on or the to v v. via vs vs.)

    x = split(" ").map do |word|
      # note: word could contain non-word characters!
      # downcase all small_words, capitalize the rest
      small_words.include?(word.gsub(/\W/, "").downcase) ? word.downcase! : word.smart_capitalize!
      word
    end
    # capitalize first and last words
    x.first.to_s.smart_capitalize!
    x.last.to_s.smart_capitalize!
    # small words after colons are capitalized
    x.join(" ").gsub(/:\s?(\W*#{small_words.join("|")}\W*)\s/) { ": #{$1.smart_capitalize} " }
  end

  def smart_capitalize
    # ignore any leading crazy characters and capitalize the first real character
    if self =~ /^['"\(\[']*([a-z])/
      i = index($1)
      x = self[i,self.length]
      # word with capitals and periods mid-word are left alone
      self[i,1] = self[i,1].upcase unless x =~ /[A-Z]/ or x =~ /\.\w+/
    end
    self
  end

  def smart_capitalize!
    replace(smart_capitalize)
  end

end
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

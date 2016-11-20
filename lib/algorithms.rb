module Algorithms

  def index_of_last_LE list, ele
    left, right = 0, list.length - 1
    while left <= right
      m = (left + right) /2
      if ele < list[m]
        right = m - 1
      elsif ele > list[m]
        left = m + 1
      else return m
      end
    end
    left
  end

end
module Algorithms
  require 'algorithms'
  
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

  # max means no bigger or equal to 
  def select_top_k arr, max, k
    min_heap = Containers::MinHeap.new
    arr.each do |id|
      id = id.to_i
      if (max == 0 || id < max)
        min_heap.push id
        min_heap.pop if min_heap.size > k
      end
    end
    result = Array.new k
    k.times { |i| result[k - i - 1] = min_heap.pop}
    result
  end

end
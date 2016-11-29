require 'csv'
require 'date'
require 'byebug'

def quick_sort tweets, left, right
  puts "current length: #{left} --- #{right}"
  mid = left + (right - left) / 2
  puts "divide at #{mid}"
  pivot = tweets[mid] # a tweet
  pivot_t = DateTime.parse pivot[2]
  i = left
  j = right
  while (i <= j) 
    while (DateTime.parse(tweets[i][2]) < pivot_t)
      i += 1
    end
    while (DateTime.parse(tweets[j][2]) > pivot_t)
      j -= 1
    end
    if (i <= j) 
      tmp = tweets[i]
      tweets[i] = tweets[j]
      tweets[j] = tmp
      i += 1
      j -= 1
    end
  end
  quick_sort tweets, left, j if j > left
  quick_sort tweets, i, right if right > i
end

tweets = CSV.read('../lib/seeddata/tweets.csv')
left = 0
right = tweets.length - 1
quick_sort tweets, left, right

CSV.open("../lib/seeddata/tweets_sort.csv", "wb") do |csv|
  tweets.each do |tweet| 
    csv << tweet
  end
end
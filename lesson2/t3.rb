def is_prime?(n)
	if n == 2
		return true
	elsif (n <= 1) || (n % 2 == 0)
    return false
  end

  i = 3
  while i <= Math.sqrt(n)
    return false if n % i == 0
    i += 2
  end
  return true
end

a = []
(1..100).each { |x| a << x if is_prime?(x) }
puts a
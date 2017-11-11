failed = 0
100000.times do
  i = 0
  250.times do
    i += rand(6) + 1
  end
  failed += 1 if i < 840
end

p "failed: #{failed}"

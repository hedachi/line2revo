failed = 0
try_times = 100000
target = 804
try_times.times do
  i = 0
  250.times do
    i += rand(6) + 1
  end
  failed += 1 if i < target
end

p "failed: #{failed} (#{failed.to_f / try_times.to_f}%)"

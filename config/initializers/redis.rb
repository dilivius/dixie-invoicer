if ENV["REDIS_URL"].present?
  $redis = Redis.new(url: ENV["REDIS_URL"])
else
  $redis = Redis.new
end

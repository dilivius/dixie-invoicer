# Note: this database should only be used by the pricing model. It will delete
# all keys upon new prices import.
if ENV["REDIS_URL"].present?
  $pricing_redis = Redis.new(url: ENV["REDIS_URL"])
else
  $pricing_redis = Redis.new
end

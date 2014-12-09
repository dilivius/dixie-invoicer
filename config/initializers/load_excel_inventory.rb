# Load into memory for now. When this gets too slow, move into Redis.
puts "Loading pricing data from excel files..."
ExcelInventory.new(Pricing.new).load

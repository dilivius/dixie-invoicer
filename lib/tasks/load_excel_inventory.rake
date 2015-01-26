desc "Load pricing data from Excel files in data/"
task :load_excel_inventory => :environment do
  puts "Loading pricing data from excel files..."
  pricing = Pricing.new
  pricing.clear
  ExcelInventory.new(pricing).load
  puts "Done."
end

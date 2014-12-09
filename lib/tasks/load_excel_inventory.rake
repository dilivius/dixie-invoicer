desc "Load pricing data from Excel files in data/"
task :load_excel_inventory => :environment do
  puts "Loading pricing data from excel files..."
  ExcelInventory.new(Pricing.new).load
  puts "Done."
end

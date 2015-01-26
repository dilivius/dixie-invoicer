require 'csv'

class ExcelInventory
  def initialize(pricing)
    @pricing = pricing
  end

  def load
    load_lk_pricing
    load_hobbs_pricing
  end

  private

  def load_lk_pricing
    load_branch_pricing("data/LK Column Large.xlsx", "L&K", 15)
    load_corporate_pricing("data/L&K contract pricing small.xlsx", "L&K", 16)
  end

  def load_hobbs_pricing
    load_branch_pricing("data/Hobbs Items with Pricing Columns and Major Pricing.csv", "Hobbs", 14)
    load_corporate_pricing("data/Hobbs Contract Pricing.xlsx", "Hobbs", 7)
  end

  def load_branch_pricing(file, branch, price_column_index)
    extract_data(file).each do |row|
      product_code = row[0]
      price = row[price_column_index]
      if price.present? && price.to_f > 0
        @pricing.set_branch(product_code, branch, price)
      end
    end
  end

  def load_corporate_pricing(file, branch, price_column_index)
    extract_data(file).each do |row|
      customer = row[0]
      product_code = row[2]
      price = row[price_column_index]
      if price.present? && price.to_f > 0
        @pricing.set_corporate(product_code, branch, customer, price)
      end
    end
  end

  def extract_data(file)
    if file.end_with?(".xlsx")
      extract_xlsx(file)
    elsif file.end_with?(".csv")
      extract_csv(file)
    else
      raise ArgumentError.new("Unknown file type: #{file}")
    end
  end

  def extract_xlsx(file)
    tiered = RubyXL::Parser.parse(file)
    tiered.worksheets.first.extract_data[1..-1]
  end

  def extract_csv(file)
    CSV.read(file)[1..-1]
  end
end

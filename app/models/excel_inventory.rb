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
    # Hobbs uses "TSP pricing" (which corresponds to the third pricing column)
    # for most of its clients except Chevron. For Chevron they use "Major" pricing
    # which is from additional column in the CSV file.
    load_branch_pricing("data/Hobbs Items with Pricing Columns and Major Pricing.csv", "Hobbs", 13)
    load_corporate_pricing_for_specific_customer("data/Hobbs Items with Pricing Columns and Major Pricing.csv", "Hobbs", "CHEVRON", 14)
  end

  def load_branch_pricing(file, branch, price_column_index)
    extract_data(file).each do |row|
      try_setting_price(branch: branch, code: row[0], price: row[price_column_index])
    end
  end

  def load_corporate_pricing_for_specific_customer(file, branch, customer, price_column_index)
    extract_data(file).each do |row|
      try_setting_price(branch: branch, customer: customer, code: row[0], price: row[price_column_index])
    end
  end

  def load_corporate_pricing(file, branch, price_column_index)
    extract_data(file).each do |row|
      try_setting_price(branch: branch, customer: row[0], code: row[2], price: row[price_column_index])
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

  def try_setting_price(code:, branch:, price:, customer: nil)
    return if price.blank? || price.to_f <= 0
    if customer
      @pricing.set_corporate(code, branch, customer, price)
    else
      @pricing.set_branch(code, branch, price)
    end
  end
end

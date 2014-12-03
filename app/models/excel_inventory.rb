class ExcelInventory
  TIERED_PRICING_FILE = "data/LK Column Large.xlsx"
  CORPORATE_PRICING_FILES = {
    "L&K" => "data/L&K contract pricing small.xlsx",
  }

  def initialize(pricing)
    @pricing = pricing
  end

  def load
    load_tiered_pricing
    load_corporate_pricing
  end

  private

  def load_tiered_pricing
    tiered_data.each do |row|
      1.upto(6) do |tier|
        product_code = row[0]
        price = row[tier + 10]
        if price.present? && price > 0
          @pricing.set_tiered(product_code, tier, price)
        end
      end
    end
  end

  def load_corporate_pricing
    corporate_data.each do |branch, data|
      data.each do |row|
        customer = row[0]
        product_code = row[2]
        price = row[16]
        if price.present? && price > 0
          @pricing.set_corporate(product_code, branch, customer, price)
        end
      end
    end
  end

  def tiered_data
    extract_data(TIERED_PRICING_FILE)
  end

  def corporate_data
    CORPORATE_PRICING_FILES.map do |branch, file|
      [branch, extract_data(file)]
    end
  end

  def extract_data(file)
    tiered = RubyXL::Parser.parse(file)
    tiered.worksheets.first.extract_data[1..-1]
  end
end

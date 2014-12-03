require 'rails_helper'

describe ExcelInventory, type: :model do
  it 'should correctly load all excel files into the Pricing model' do
    pricing = Pricing.new
    ExcelInventory.new(pricing).load

    # first row in the tiered pricing file, tier 1 company
    expect(pricing.get('14ST300', 'OTHER', 'WESTEX')).to eq(28.30)
    # first row in the tiered pricing file, tier 5 company
    expect(pricing.get('14ST300', 'L&K', 'WESTEX')).to eq(0)
     # last row in the tiered pricing file
    expect(pricing.get('BRKQ040', 'L&K', 'WESTEX')).to eq(23.66)
    # first row in the L&K corporate pricing file
    expect(pricing.get('XLK965', 'L&K', '96TRIANGLE')).to eq(85)
    # last row in the L&K corporate pricing file
    expect(pricing.get('1OAEK', 'L&K', '96ZAVANNA')).to eq(112)
  end
end

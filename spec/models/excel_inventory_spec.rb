require 'rails_helper'

describe ExcelInventory, type: :model do
  describe '.load' do
    before(:all) do
      @pricing = Pricing.new
      ExcelInventory.new(@pricing).load
    end

    it 'should correctly load standard L&K pricing file into the Pricing model' do
      # first row in the standard L&K pricing file
      expect(@pricing.get('14ST300', 'L&K', 'WESTEX')).to eq(0)
       # last row in the standard L&K pricing file
      expect(@pricing.get('BRKQ040', 'L&K', 'WESTEX')).to eq(23.66)
    end

    it 'should correctly load corporate L&K pricing file into the Pricing model' do
      # first row in the L&K corporate pricing file
      expect(@pricing.get('XLK965', 'L&K', '96TRIANGLE')).to eq(85)
      # last row in the L&K corporate pricing file
      expect(@pricing.get('1OAEK', 'L&K', '96ZAVANNA')).to eq(112)
    end

    it 'should correctly load standard Hobbs pricing file into the Pricing model' do
      # first row in the standard Hobbs pricing file
      expect(@pricing.get('1280BT', 'Hobbs', 'WESTEX')).to eq(108.60)
       # last row in the standard Hobbs pricing file
      expect(@pricing.get('WR300', 'Hobbs', 'WESTEX')).to eq(2.14)
    end

    it 'should correctly load corporate Hobbs pricing file into the Pricing model' do
      # first row in the Hobbs corporate pricing file
      expect(@pricing.get('1280BT190', 'Hobbs', '50CHEVHOBB')).to eq(99.18)
      # last row in the Hobbs corporate pricing file
      expect(@pricing.get('1TR690', 'Hobbs', '50CHEVRONE')).to eq(15.68)
    end
  end
end

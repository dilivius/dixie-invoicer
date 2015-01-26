require 'rails_helper'

describe ExcelInventory, type: :model do
  # Excel files are loaded into rspec through a rake task, so we can just test
  # the results here.
  describe '.load' do
    let(:pricing) { Pricing.new }

    it 'should correctly load standard L&K pricing file into the Pricing model' do
      # first row in the standard L&K pricing file
      expect(pricing.get('14ST300', 'L&K', 'WESTEX')).to eq(0)
       # last row in the standard L&K pricing file
      expect(pricing.get('BRKQ040', 'L&K', 'WESTEX')).to eq(23.66)
    end

    it 'should correctly load corporate L&K pricing file into the Pricing model' do
      # first row in the L&K corporate pricing file
      expect(pricing.get('XLK965', 'L&K', '96TRIANGLE')).to eq(85)
      # last row in the L&K corporate pricing file
      expect(pricing.get('1OAEK', 'L&K', '96ZAVANNA')).to eq(112)
    end

    it 'should correctly load standard Hobbs pricing file into the Pricing model' do
      # first row with non-zero price in the Hobbs pricing file
      expect(pricing.get('14ST300', 'Hobbs', 'WESTEX')).to eq(28.30)
      # first row with a defined major price in the Hobbs pricing file
      expect(pricing.get('LIG165', 'Hobbs', 'WESTEX')).to eq(121)
      # last row in the Hobbs pricing file
      expect(pricing.get('14LBT1144', 'Hobbs', 'WESTEX')).to eq(72)
    end

    it 'should correctly load corporate Hobbs pricing file into the Pricing model' do
      # first row with a defined major price in the Hobbs pricing file
      expect(pricing.get('LIG165', 'Hobbs', 'CHEVRON')).to eq(102.85)
      # last row with a defined major price in the Hobbs pricing file
      expect(pricing.get('CLA516', 'Hobbs', 'CHEVRON')).to eq(3.51)
    end
  end
end

require "prawn"

class Invoice
  def initialize
    @file = Tempfile.new('invoice')
    generate
  end

  def pdf_data
    @file.rewind
    @file.read
  end

  def filename
    'invoice.pdf'
  end

  private

  def generate
    Prawn::Document.generate(@file.path) do
      text "Hello World!"
    end
  end
end

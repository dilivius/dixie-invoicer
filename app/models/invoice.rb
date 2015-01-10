require "prawn"
require "prawn/table"

class Invoice
  def initialize(job)
    @job = job
    @file = Tempfile.new('invoice')
    generate
  end

  def pdf_data
    @file.rewind
    @file.read
  end

  def filename
    "invoice-#{@job['common_id']}.pdf"
  end

  private

  def generate
    Prawn::Document.generate(@file.path) do |pdf|
      pdf.font "Helvetica"

      pdf.define_grid(columns: 5, rows: 8, gutter: 10)

      basics_with_logo(pdf)
      job_number_and_dates(pdf)
      products_table(pdf)
      signature_line(pdf)
    end
  end

  def basics_with_logo(pdf)
    pdf.grid([0,0], [1,1]).bounding_box do
      pdf.image image("dixie-electric-logo.png"), at: [170,160], width: 200

      pdf.text "Invoice No: 0001", align: :left
      pdf.text "Customer No: 0001", align: :left
      pdf.text "Name: Taylor Swift", align: :left
      pdf.text "Location: Somewhere, TX", align: :left

      pdf.text "Work Description:", align: :left
      pdf.move_down 10
      pdf.bounding_box([0,100], width: 380, height: 90) do
        pdf.stroke_bounds
        pdf.text_box @job.fetch('description', ""), at: [10, pdf.cursor - 10]
      end
    end
  end

  def job_number_and_dates(pdf)
    pdf.grid([0,3.6], [1,4]).bounding_box do
      pdf.move_down 10
      pdf.text "Job No: #{@job['common_id']}", align: :left
      pdf.text "Date: #{performed_date}", align: :left
      pdf.text "No:", align: :left
      pdf.text "No:", align: :left
      pdf.text "Start:", align: :left
      pdf.text "Stop:", align: :left
      pdf.text "Start:", align: :left
      pdf.text "Stop:", align: :left
    end
  end

  def products_table(pdf)
    pdf.move_down 10
    items = []
    items << ["Stock No.", "Quantity", "Description", "Rate", "Subtotal"]
    items.concat(product_lines)
    items << ["", total_quantity.to_s, "", "", "%.2f" % total_price]

    pdf.table items, header: true, column_widths: { 0 => 60, 1 => 60, 2 => 300, 3 => 60, 4 => 60, 5 => 60}, row_colors: ["d2e3ed", "FFFFFF"] do
      style(columns(1)) {|x| x.align = :right }
      style(columns(3)) {|x| x.align = :right }
      style(columns(4)) {|x| x.align = :right }
    end
  end

  def signature_line(pdf)
    pdf.move_down 20
    pdf.text "Ordered by:     ___________________________________          Incomplete         Complete"
  end

  def image(name)
    Rails.root.join("app/assets/images/pdf/#{name}")
  end

  def performed_date
    if time = @job['performed_at']
      Time.at(time/1000).to_date
    end
  end

  def product_lines
    @product_lines ||= @job.fetch('products', []).map do |product|
      code, quantity, name = product.values_at('code', 'quantity', 'name')
      price = Pricing.new.get(code, branch, customer)
      subtotal = price * quantity
      [code, quantity.to_s, name, "%.2f" % price, "%.2f" % subtotal]
    end
  end

  def total_quantity
    product_lines.map(&:second).map(&:to_i).inject(0, :+)
  end

  def total_price
    product_lines.map(&:fourth).map(&:to_f).inject(0, :+)
  end

  def branch
    "Hobbs" # TODO: figure out branch by the @job['owner_username']
  end

  def customer
    @job['company_name']
  end
end

class ApiController < ApplicationController
  before_action do
    require_role("admin")
  end

  def invoice
    invoice = Invoice.new
    send_data invoice.pdf_data, type: 'application/pdf',
      disposition: "attachment; filename=#{invoice.filename}"
  end
end

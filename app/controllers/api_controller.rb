class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action do
    require_role("admin")
  end

  def invoice
    invoice = Invoice.new(JSON.parse(params[:job]))
    send_data invoice.pdf_data, type: 'application/pdf',
      disposition: "attachment; filename=#{invoice.filename}"
  end
end

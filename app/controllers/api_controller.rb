class ApiController < ApplicationController
  before_action do
    require_role("admin")
  end

  def invoice
    render text: 'OK'
  end
end

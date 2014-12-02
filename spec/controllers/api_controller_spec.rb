require 'rails_helper'

RSpec.describe ApiController, type: :controller do
  describe 'invoice' do
    it 'should return the PDF invoice file' do
      make_session_active
      get :invoice
      expect(response).to be_ok
      expect(response.body[0..7]).to eq("%PDF-1.3")
      expect(response.headers["Content-Type"]).to eq("application/pdf")
      expect(response.headers["Content-Disposition"]).to eq("attachment; filename=invoice.pdf")
    end

    it "should not allow to be used by normal users" do
      make_session_active("user")
      get :invoice
      expect(response.status).to eq(401)
      expect(response.body).to be_blank
    end
  end

  def make_session_active(role="admin")
    session[:current_user] = {
      "username" => "homer",
      "roles" => [role],
      "expire_at" => 1.month.from_now.to_i
    }
  end
end

require 'rails_helper'

RSpec.describe ApiController, type: :controller do
  describe 'invoice' do
    it 'should return the invoice' do
      make_session_active
      get :invoice
      expect(response).to be_ok
      expect(response.body).to eq("OK")
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

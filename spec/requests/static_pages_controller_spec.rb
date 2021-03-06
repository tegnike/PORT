require "rails_helper"

RSpec.describe StaticPagesController, type: :request do
  describe "GET #root" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include "#{full_title("")}"
    end
  end

  describe "GET #help" do
    it "returns http success" do
      get help_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include "#{full_title("ヘルプ")}"
    end
  end

  describe "GET #about" do
    it "returns http success" do
      get about_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include "#{full_title("PORTとは")}"
    end
  end

  describe "GET #policy" do
    it "returns http success" do
      get policy_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include "#{full_title("プライバシーポリシー")}"
    end
  end

  describe "GET #terms" do
    it "returns http success" do
      get terms_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include "#{full_title("利用規約")}"
    end
  end
end

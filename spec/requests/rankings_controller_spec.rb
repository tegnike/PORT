require "rails_helper"

RSpec.describe RankingsController, type: :request do
  describe "GET #favorite" do
    it "returns http success" do
      get rankings_favorite_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include "#{full_title("お気に入りランキング")}"
    end
  end

  describe "GET #total_pv" do
    it "returns http success" do
      get rankings_total_pv_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include "#{full_title("総合アクセスランキング")}"
    end
  end

  describe "GET #weekly_pv" do
    it "returns http success" do
      get rankings_weekly_pv_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include "#{full_title("週間アクセスランキング")}"
    end
  end
end

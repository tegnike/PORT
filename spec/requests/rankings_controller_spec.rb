require "rails_helper"

RSpec.describe RankingsController, type: :request do
  describe "GET #favorite" do
    it "returns http success" do
      get rankings_favorite_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include "#{full_title("お気に入りランキング")}"
    end
  end
end

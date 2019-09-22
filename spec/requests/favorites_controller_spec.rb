require "rails_helper"

RSpec.describe FavoritesController, type: :request do
  describe "PUT #create" do
    context "try to favorite before log in" do
      subject { post favorites_path }
      it "doesnt' increase favorite count and redirect login_url" do
        expect { subject }.to change { Favorite.count }.by(0)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:user) { create(:user) }
    context "try to unfavorite before log in" do
      subject { delete favorite_path(user) }
      it "doesnt' decrease favorite count and redirect login_url" do
        expect { subject }.to change { Favorite.count }.by(0)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end

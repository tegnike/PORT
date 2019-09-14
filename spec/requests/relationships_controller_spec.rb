require "rails_helper"

RSpec.describe RelationshipsController, type: :request do
  describe "PUT #create" do
    context "try to follow before log in" do
      subject { post relationships_path }
      it "doesnt' increase relationship count and redirect login_url" do
        expect { subject }.to change { Relationship.count }.by(0)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:user) { create(:user) }
    context "try to unfollow before log in" do
      subject { delete relationship_path(user) }
      it "doesnt' increase relationship count and redirect login_url" do
        expect { subject }.to change { Relationship.count }.by(0)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end

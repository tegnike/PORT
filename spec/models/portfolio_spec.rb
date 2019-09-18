require "rails_helper"

RSpec.describe Portfolio, type: :model do
  let(:portfolio) { create(:portfolio) }

  describe "Portfolio validation" do
    it "shows user is valid" do
      expect(portfolio).to be_valid
    end
  end

  describe "Portfolio's columns validation" do
    it { is_expected.to validate_presence_of :user_id }
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_length_of(:title).is_at_most(100) }
    it { is_expected.to validate_presence_of :content }
    it { is_expected.to validate_presence_of :web_url }
    it { is_expected.to validate_presence_of :git_url }
  end

  describe "make portfolios which have different created_at" do
    let!(:first) { create(:portfolio, created_at: 10.minutes.ago) }
    let!(:second) { create(:portfolio, created_at: 2.hours.ago) }
    let!(:last) { create(:portfolio, created_at: Time.zone.now) }
    it "expess portfolios by descending order" do
      expect(Portfolio.first).to eq last
    end
  end
end

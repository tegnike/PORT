require "rails_helper"

RSpec.describe Portfolio, type: :model do
  let(:portfolio) { create(:portfolio) }

  describe "Portfolio validation" do
    it "shows user is valid" do
      expect(portfolio).to be_valid
    end
  end

  describe "Portfolio's columns validation" do
    describe "presence" do
      it { is_expected.to validate_presence_of :user_id }
      it { is_expected.to validate_presence_of :title }
      it { is_expected.to validate_presence_of :content }
      it { is_expected.to validate_presence_of :web_url }
      it { is_expected.to validate_presence_of :git_url }
    end

    describe "characters" do
      it { is_expected.to validate_length_of(:title).is_at_most(100) }
    end

    describe "url format" do
      context "invalid format" do
        it "should be invalid" do
          invalid_url = %w[http test.com test http.com]
          invalid_url.each do |url|
            portfolio.web_url = url
            expect(portfolio).not_to be_valid
          end
          invalid_url.each do |url|
            portfolio.git_url = url
            expect(portfolio).not_to be_valid
          end
        end
      end
      context "valid format" do
        it "should be valid" do
          invalid_url = %w[http://localhost:3000 https://port-port.herokuapp.com]
          invalid_url.each do |url|
            portfolio.web_url = url
            expect(portfolio).to be_valid
          end
          invalid_url.each do |url|
            portfolio.git_url = url
            expect(portfolio).to be_valid
          end
        end
      end
    end
  end
end

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
          git_invalid_url = %w[http test.com test http.com http://localhost:3000 https://port-port.herokuapp.com]
          git_invalid_url.each do |url|
            portfolio.git_url = url
            expect(portfolio).not_to be_valid
          end
        end
      end
      context "valid format" do
        it "should be valid" do
          valid_url = %w[http://localhost:3000 https://port-port.herokuapp.com]
          valid_url.each do |url|
            portfolio.web_url = url
            expect(portfolio).to be_valid
          end
          git_valid_url = %w[https://github.com/tegnike/PORT/]
          git_valid_url.each do |url|
            portfolio.git_url = url
            expect(portfolio).to be_valid
          end
        end
      end
    end
  end
end

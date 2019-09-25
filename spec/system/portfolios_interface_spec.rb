require "rails_helper"

RSpec.describe "PortfoliosInterfaceTest", type: :system, js: true do
  describe "portfolio post UI" do
    let(:user1) { create_user }
    let(:user2) { create(:user) }
    before {
      create_list(:portfolio, 10, user_id: user1.id)
      create_list(:portfolio, 10, user_id: user2.id)
      login(user1)
      visit root_path
    }
    context "try to post an invalid portfolio" do
      before {
        fill_in "portfolio_title", with: ""
        fill_in_rich_text_area "portfolio_content", with: ""
        attach_file "portfolio_image", "#{Rails.root}/spec/factories/rails.png"
        fill_in "portfolio_web_url", with: ""
        fill_in "portfolio_git_url", with: ""
        click_button "Post"
        sleep 1
      }
      it "can't post a portfolio" do
        expect(page).to have_css ".alert"
      end
    end
    context "try to post a valid portfolio" do
      before {
        fill_in "portfolio_title", with: "test_title"
        fill_in_rich_text_area "portfolio_content", with: "test_content"
        attach_file "portfolio_image", "#{Rails.root}/spec/factories/rails.png"
        fill_in "portfolio_web_url", with: "http://example/web_url"
        fill_in "portfolio_git_url", with: "http://example/git_url"
        click_button "Post"
      }
      it "can post a portfolio" do
        expect(current_path).to eq user_path(user1)
        expect(page).to have_selector ".title", text: "title"
        expect(page).to have_selector ".content", text: "content"
        expect(page).to have_css ".image"
        expect(page).to have_selector ".web_url", text: "web_url"
        expect(page).to have_selector ".git_url", text: "git_url"
      end
    end
    context "push delete button" do
      subject {
        visit user_path(user1)
        first("ol li").click_link "削除する"
        page.driver.browser.switch_to.alert.accept
        find ".notice", text: "ポートフォリオを削除しました。"
      }
      it "delete a portfolio" do
        expect { subject }.to change { Portfolio.count }.by(-1)
      end
    end
    context "access to other user page" do
      before { visit user_path(user2) }
      it "doesn't show delete link" do
        expect(page).not_to have_link "削除する"
      end
    end
  end
  describe "portfolio's post count" do
    let!(:user) { create(:user, email: "user@example.com", password: "password", password_confirmation: "password") }
    before { login(user) }
    context "user doesn't post any portfolio yet" do
      before { visit user_path(user) }
      it "shows '0 portfolios'" do
        expect(page).to have_content "0 portfolios"
      end
    end
    context "user post a portfolio" do
      before {
        fill_in "portfolio_title", with: "test_title"
        fill_in_rich_text_area "portfolio_content", with: "test_content"
        attach_file "portfolio_image", "#{Rails.root}/spec/factories/rails.png"
        fill_in "portfolio_web_url", with: "http://example/web_url"
        fill_in "portfolio_git_url", with: "http://example/git_url"
        click_button "Post"
        visit user_path(user)
      }
      it "shows '1 portfolio'" do
        expect(page).to have_content "1 portfolio"
      end
    end
  end
end

require "rails_helper"

RSpec.describe "PortfoliosInterfaceTest", type: :system, js: true do
  describe "portfolio post UI" do
    let(:user1) { create_user }
    let(:user2) { create(:user) }
    before {
      create_list(:portfolio, 10, user_id: user1.id)
      create_list(:portfolio, 10, user_id: user2.id)
      login(user1)
      visit new_portfolio_path
    }
    context "try to post an invalid portfolio" do
      before {
        fill_in "portfolio_title", with: ""
        fill_in_rich_text_area "portfolio_content", with: ""
        attach_file "portfolio_image", "#{Rails.root}/spec/factories/rails.png"
        fill_in "portfolio_web_url", with: ""
        fill_in "portfolio_git_url", with: ""
        click_button "投稿"
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
        click_button "投稿"
      }
      it "can post a portfolio" do
        expect(current_path).to eq portfolio_path(Portfolio.find_by(title: "test_title"))
        expect(page).to have_selector ".title", text: "test_title"
        expect(page).to have_selector ".content", text: "test_content"
        expect(page).to have_css ".image"
        expect(page).to have_selector ".web_url", text: "WEBサイト"
        expect(page).to have_selector ".git_url", text: "Github"
      end
    end
    context "push delete button" do
      subject {
        visit portfolio_path(Portfolio.find_by(user_id: user1.id))
        click_link "削除"
        page.driver.browser.switch_to.alert.accept
        find ".alert-notice", text: "ポートフォリオを削除しました。"
      }
      it "delete a portfolio" do
        expect { subject }.to change { Portfolio.count }.by(-1)
      end
    end
    context "access to other user's portfolio page" do
      before { visit portfolio_path(Portfolio.find_by(user_id: user2.id)) }
      it "doesn't show delete link" do
        expect(page).not_to have_link "削除"
      end
    end
  end

  describe "portfolio's post count" do
    let!(:user) { create_user }
    before { login(user) }
    context "user doesn't post any portfolio yet" do
      before { visit user_path(user) }
      it "shows '0 ポートフォリオ'" do
        expect(page).to have_content "0 ポートフォリオ"
      end
    end
    context "user post a portfolio" do
      before {
        fill_in "portfolio_title", with: "test_title"
        fill_in_rich_text_area "portfolio_content", with: "test_content"
        attach_file "portfolio_image", "#{Rails.root}/spec/factories/rails.png"
        fill_in "portfolio_web_url", with: "http://example/web_url"
        fill_in "portfolio_git_url", with: "http://example/git_url"
        click_button "投稿"
        visit user_path(user)
      }
      it "shows '1 ポートフォリオ'" do
        expect(page).to have_content "1 ポートフォリオ"
      end
    end
  end

  describe "pageview count" do
    let!(:user1) { create_user }
    let(:user2) { create(:user) }
    let(:portfolio1) { create(:portfolio, user_id: user1.id) }
    let(:portfolio2) { create(:portfolio, user_id: user2.id) }
    context "access to my portfolio page" do
      before {
        login(user1)
        visit portfolio_path(portfolio1)
      }
      it "doesn't increase pv by owner's access" do
        expect(page).to have_content "0 views"
      end
    end
    context "access to the portfolio page 2 times by other user" do
      before {
        2.times do
          login(user2)
          visit portfolio_path(portfolio1)
          logout
        end
        login(user1)
        visit portfolio_path(portfolio1)
      }
      it "increases just 1 pv" do
        expect(page).to have_content "1 views"
      end
    end
    context "access to other user's portfolio page" do
      before {
        login(user1)
        visit portfolio_path(portfolio2)
      }
      it "doesn't show pv count" do
        expect(page).not_to have_content "views"
      end
    end
  end
end

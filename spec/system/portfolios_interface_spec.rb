require "rails_helper"

RSpec.describe "PortfoliosInterfaceTest", type: :system, js: true do
  subject(:correct_post) {
    fill_in "portfolio_title", with: "test_title"
    fill_in_rich_text_area "portfolio_content", with: "test_content"
    attach_file "portfolio_image", "#{Rails.root}/spec/factories/rails.png"
    fill_in "portfolio_web_url", with: "http://example/web_url"
    fill_in "portfolio_git_url", with: "https://github.com/git_url"
    fill_in_rich_text_area "progress_content", with: "test_prorgess"
    click_button "投稿"
  }

  describe "portfolio post UI" do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    before {
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
        fill_in_rich_text_area "progress_content", with: ""
        click_button "投稿"
        sleep 1
      }
      it "can't post a portfolio" do
        expect(page).to have_css ".alert"
      end
    end
    context "try to post a valid portfolio" do
      before { correct_post }
      it "can post a portfolio" do
        expect(current_path).to eq portfolio_path(Portfolio.find_by(title: "test_title"))
        expect(page).to have_selector ".title", text: "test_title"
        expect(page).to have_selector ".content", text: "test_content"
        expect(page).to have_css ".image"
        expect(page).to have_selector ".portfolio-links", text: "WEBサイト"
        expect(page).to have_selector ".portfolio-links", text: "Github"
        expect(page).to have_selector ".progress-whole", text: "企画"
        expect(page).to have_selector ".progress-whole", text: "test_prorgess"
      end
    end
    context "try to post without urls and progress status not release" do
      before {
        fill_in "portfolio_title", with: "test_title"
        fill_in_rich_text_area "portfolio_content", with: "test_content"
        attach_file "portfolio_image", "#{Rails.root}/spec/factories/rails.png"
        fill_in "portfolio_web_url", with: ""
        fill_in "portfolio_git_url", with: ""
        select "企画", from: "現在のステータス"
        fill_in_rich_text_area "progress_content", with: "test_prorgess"
        click_button "投稿"
      }
      it "can post a portfolio" do
        expect(current_path).to eq portfolio_path(Portfolio.find_by(title: "test_title"))
        expect(page).to have_selector ".title", text: "test_title"
        expect(page).to have_selector ".content", text: "test_content"
        expect(page).to have_css ".image"
        expect(page).to have_selector ".without-url", text: "WEBサイト"
        expect(page).to have_selector ".without-url", text: "Github"
        expect(page).to have_selector ".progress-whole", text: "企画"
        expect(page).to have_selector ".progress-whole", text: "test_prorgess"
      end
    end
    context "try to post without urls and progress status release" do
      before {
        fill_in "portfolio_title", with: "test_title"
        fill_in_rich_text_area "portfolio_content", with: "test_content"
        attach_file "portfolio_image", "#{Rails.root}/spec/factories/rails.png"
        fill_in "portfolio_web_url", with: ""
        fill_in "portfolio_git_url", with: ""
        select "企画", from: "現在のステータス"
        fill_in_rich_text_area "progress_content", with: "test_prorgess"
        click_button "投稿"
      }
      it "can't post a portfolio" do
        expect(page).to have_css ".alert"
      end
    end
    context "push delete button" do
      before { correct_post }
      subject {
        visit portfolio_path(Portfolio.find_by(user: user1))
        first(".portfolio-header .dropdown").click_on
        click_link "削除"
        page.driver.browser.switch_to.alert.accept
        find ".alert-notice", text: "ポートフォリオを削除しました。"
      }
      it "delete a portfolio" do
        expect { subject }.to change { Portfolio.count }.by(-1)
      end
    end
    context "access to other user's portfolio page" do
      let(:portfolio2) { create(:portfolio, user: user2) }
      let!(:progress2) { create(:progress, portfolio: portfolio2) }
      before {
        visit portfolio_path(Portfolio.find_by(user: user2))
      }
      it "doesn't show delete link" do
        expect(page).not_to have_link "削除"
      end
    end
  end

  describe "portfolio's post count" do
    let!(:user) { create(:user) }
    before { login(user) }
    context "user doesn't post any portfolio yet" do
      before { visit user_path(user) }
      it "shows '0 件のポートフォリオ'" do
        expect(page).to have_content "0 件のポートフォリオ"
      end
    end
    context "user post a portfolio" do
      before {
        visit new_portfolio_path
        correct_post
        visit user_path(user)
      }
      it "shows '1 件のポートフォリオ'" do
        expect(page).to have_content "1 件のポートフォリオ"
      end
    end
  end

  describe "pageview count" do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:portfolio1) { create(:portfolio, user: user1) }
    let(:portfolio2) { create(:portfolio, user: user2) }
    let!(:progress1) { create(:progress, portfolio: portfolio1) }
    let!(:progress2) { create(:progress, portfolio: portfolio2) }
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

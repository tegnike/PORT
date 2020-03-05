require "rails_helper"

RSpec.describe "ProgressesInterfaceTest", type: :system, js: true do
  subject(:correct_post)  {
    fill_in "progress_title", with: "progress_title1"
    fill_in_rich_text_area "progress_content", with: "progress_content1"
    click_button "投稿"
  }

  describe "progress post UI" do
    let(:user) { create(:user) }
    let(:portfolio) { create(:portfolio, user: user) }
    let!(:progress) { create(:progress, portfolio: portfolio) }
    let(:user2) { create(:user) }
    let(:portfolio2) { create(:portfolio, user: user2) }
    let!(:progress2) { create(:progress, portfolio: portfolio2) }

    before {
      login(user)
      visit new_portfolio_progress_path(portfolio)
    }
    context "try to post an invalid progress" do
      before {
        fill_in "progress_title", with: ""
        fill_in_rich_text_area "progress_content", with: ""
        click_button "投稿"
        sleep 1
      }
      it "can't post a progress" do
        expect(page).to have_css ".alert"
      end
    end
    context "try to post a valid portfolio" do
      before { correct_post }
      it "shows a posted progress" do
        expect(page).to have_selector ".progress-whole", text: "progress_title1"
        expect(page).to have_selector ".progress-whole", text: "progress_content1"
      end
    end
    context "try to post a 2nd valid portfolio" do
      before {
        visit new_portfolio_progress_path(portfolio)
        fill_in "progress_title", with: "progress_title2"
        fill_in_rich_text_area "progress_content", with: "progress_content2"
        click_button "投稿"
      }
      it "shows the latest posted progress" do
        expect(page).not_to have_selector ".progress-whole", text: "progress_title1"
        expect(page).to have_selector ".progress-whole", text: "progress_title2"
        expect(page).not_to have_selector ".progress-whole", text: "progress_content1"
        expect(page).to have_selector ".progress-whole", text: "progress_content2"
      end
    end
    context "push delete button" do
      before { correct_post }
      subject {
        visit portfolio_path(portfolio)
        first(".progress-header .dropdown").click_on
        click_link "削除"
        page.driver.browser.switch_to.alert.accept
        find ".alert-notice", text: "プログレスを削除しました。"
      }
      it "delete a portfolio" do
        expect { subject }.to change { Progress.count }.by(-1)
      end
    end
    context "access to other user's portfolio page" do
      before {
        visit portfolio_path(portfolio2)
      }
      it "doesn't show delete link" do
        expect(page).not_to have_css ".progress-header .dropdown"
      end
    end
  end
end

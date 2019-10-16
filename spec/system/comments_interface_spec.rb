require "rails_helper"

RSpec.describe "CommentsInterfaceTest", type: :system, js: true do
  describe "comment post UI" do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:portfolio) { create(:portfolio, user: user) }
    let!(:progress) { create(:progress, portfolio: portfolio) }
    before { login(user) }

    context "try to post an invalid comment" do
      before {
        visit portfolio_path(portfolio)
        fill_in_rich_text_area "comment_comment", with: ""
        click_button "投稿"
        sleep 1
      }
      it "can't post a comment" do
        expect(page).to have_css ".alert"
      end
    end
    context "try to post valid comments" do
      before {
        visit portfolio_path(portfolio)
        fill_in_rich_text_area "comment_comment", with: "test_comment1"
        click_button "投稿"
      }
      subject(:second_post) {
        visit portfolio_path(portfolio)
        fill_in_rich_text_area "comment_comment", with: "test_comment2"
        click_button "投稿"
      }
      it "shows a posted comment" do
        expect(page).to have_selector "#comments", text: "test_comment1"
      end
      it "shows both posted comments" do
        second_post
        expect(page).to have_selector "#comments", text: "test_comment1"
        expect(page).to have_selector "#comments", text: "test_comment2"
      end
    end
    context "try to update a comment invalidly" do
      before {
        create(:comment, user: user, progress: progress)
        visit portfolio_path(portfolio)
        first("#comments").click_link "編集"
        fill_in_rich_text_area "edit_comment", with: ""
        click_button "更新"
        sleep 1
      }
      it "shows a error message" do
        expect(page).to have_selector ".alert", text: "コメントを編集できませんでした。"
      end
    end
    context "try to update a comment validly" do
      before {
        create(:comment, user: user, progress: progress)
        visit portfolio_path(portfolio)
        first("#comments").click_link "編集"
        fill_in_rich_text_area "edit_comment", with: "test_comment3"
        click_button "更新"
        sleep 1
      }
      it "shows a update comment" do
        expect(page).to have_selector ".alert", text: "コメントを編集しました。"
        expect(page).to have_selector "#comments", text: "test_comment3"
      end
    end
    context "push delete button" do
      before {
        create(:comment, user: user2, progress: progress)
        visit portfolio_path(portfolio)
        fill_in_rich_text_area "comment_comment", with: "test_comment"
        click_button "投稿"
      }
      subject {
        first("#comments").click_link "削除"
        page.driver.browser.switch_to.alert.accept
        find ".alert-notice", text: "コメントを削除しました。"
      }
      it "delete a comment" do
        expect { subject }.to change { Comment.count }.by(-1)
      end
      it "doesn't show other user's delete button" do
        expect(page.all("#comments")).not_to have_link "削除"
      end
    end
  end
end

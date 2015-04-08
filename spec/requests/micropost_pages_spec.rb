require 'spec_helper'

describe "Micropost pages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do
      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }

      end
    end

    describe "with valid information" do
      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end

    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as current user" do
      before { visit root_path }
      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end

  describe "件数表示" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe 'ポスト1件の場合' do
      before { visit root_path }
      it { should have_content('1　micropost') }
    end

    describe '2件ポストの場合' do
      before do
        FactoryGirl.create(:micropost, user: user)
        visit root_path
      end
      it { should have_content('2　microposts') }
    end
  end


  describe "pagination" do
    before do
      35.times { FactoryGirl.create(:micropost, user: user) }
      visit root_path
    end
    after { user.microposts.delete_all }

    it do
      should have_selector('div.pagination')
    end

    it "should list each user" do
      Micropost.paginate(page: 1).each do |micropost|
        expect(page).to have_selector("li##{micropost.id}")
      end
    end
  end

  describe "他のユーザーのポスト" do
    let(:admin) { FactoryGirl.create(:admin) }

    before do
      FactoryGirl.create(:micropost, user: user)
      sign_in admin
      visit user_path(user)
    end

    it { should_not have_link("delete") }


  end

end
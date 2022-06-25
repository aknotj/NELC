# frozen_string_literal: true

require 'rails_helper'

  describe 'ユーザーのテスト' do
    let(:user) {FactoryBot.create(:user)}
    describe 'トップ画面のテスト' do
      before do
        visit root_path
      end
      context 'TOP画面の表示の確認' do
        it 'root_pathが"/"であるか' do
          expect(current_path).to eq('/')
        end
        it 'ヘッダーに新規登録ページ・ログインページへのリンクが表示されているか' do
          join_link = find_all('a')[1]
          expect(join_link.native.inner_text).to match(/Join新規登録/i)
          login_link = find_all('a')[2]
          expect(login_link.native.inner_text).to match(/Log in/i)
        end
        it 'TOP画面に新規登録ページ・ログインページへのリンクが表示されているか' do
          join_link = find_all('a')[3]
          expect(join_link.native.inner_text).to match(/Join now/i)
          login_link = find_all('a')[4]
          expect(login_link.native.inner_text).to match(/Log in/i) 
          end
      end
    end
    describe '新規登録画面のテスト' do
      before do
        visit new_user_registration_path
      end
      context '新規登録画面の表示の確認' do
        it 'ユーザー名、email、passwordのフォーム、Sign upボタンが表示されているか' do
          expect(page).to have_field 'user[name]'
          expect(page).to have_field 'user[email]'
          expect(page).to have_field 'user[password]'
          expect(page).to have_button 'Sign up'
        end
      end
      context '新規登録処理に関するテスト' do
        it '新規投稿に失敗する' do
          click_button 'Sign up'
          expect(current_path).to eq('/users')
          expect(page).to have_content 'be blank'
        end
        it '新規登録に成功しWelcomeページが表示されるか' do
          fill_in 'user[name]', with: 'rspec'
          fill_in 'user[email]', with: 'rspec@nelc.com'
          fill_in 'user[password]', with: '0000000'
          click_button 'Sign up'
          expect(current_path).to eq user_welcome_path(User.last)
          expect(page).to have_field 'user[name]'
          expect(page).to have_field 'user[name_jap]'
          expect(page).to have_field 'user[gender]'
          expect(page).to have_field 'user[native_language]'
          expect(page).to have_field 'user[learning_language]'
          expect(page).to have_field 'user[introduction]'
          expect(page).to have_field 'user[email]'
          expect(page).to have_field 'user[time_zone]'
          expect(page).to have_field 'user[profile_image]'
          expect(page).to have_button 'Save / 保存'
        end
      end
    end
    describe 'Welcomeページのテスト' do
      before do
        sign_in user
        visit user_welcome_path(user)
      end
      context 'ユーザー情報編集処理に関するテスト' do
        it 'ユーザー情報の更新に成功する' do
          fill_in 'user[name_jap]', with: 'テストユーザー'
          select 'Male', from: 'user[gender]'
          select 'English', from: 'user[native_language]'
          select 'Japanese', from: 'user[learning_language]'
          fill_in 'user[introduction]', with: 'テスト'
          select '(GMT+09:00) Tokyo', from: 'user[time_zone]'
          click_button 'Save / 保存'
          expect(current_path).to eq user_path(user)
        end
        it 'ユーザー情報の更新に失敗する' do
          fill_in 'user[name]', with: ""
          click_button 'Save / 保存'
          expect(page).to have_content 'be blank'
        end
      end
    end
    describe 'プロフィール画面のテスト' do
      before do
        sign_in user
        visit user_path(user)
      end
      context 'プロフィール画面の表示の確認' do
        it 'プロフィールの情報が表示される' do
          expect(page).to have_content user.name
        end
        it 'ヘッダーのリンクが表示される' do
          root_link = find_all('a')[0]
          expect(root_link.native.inner_text).to match(/NELC/i)
          post_link = find_all('a')[1]
          expect(post_link.native.inner_text).to match(/New Post/i)
          chat_link = find_all('a')[2]
          expect(chat_link.native.inner_text).to match(/Chat Room/i)
          friends_link = find_all('a')[3]
          expect(friends_link.native.inner_text).to match(/Friends/i)
          search_link = find_all('a')[4]
          expect(search_link.native.inner_text).to match(/Search/i)
          profile_link = find_all('a')[7]
          expect(profile_link.native.inner_text).to match(/Profile/i)
          post_link = find_all('a')[8]
          expect(post_link.native.inner_text).to match(/New Post/i)
          bookmarks_link = find_all('a')[9]
          expect(bookmarks_link.native.inner_text).to match(/bookmarks/i)
          friends_link = find_all('a')[10]
          expect(friends_link.native.inner_text).to match(/My Friends/i)
          logout_link = find_all('a')[11]
          expect(logout_link.native.inner_text).to match(/log out/i)
        end
        it '新規投稿・プロフィール編集リンクが表示される' do
          post_link = find_all('a')[20]
          expect(post_link.native.inner_text).to match(/New post/i)
          edit_link = find_all('a')[21]
          expect(edit_link.native.inner_text).to match(/edit profile/i) 
        end
        it 'Friendsヘディング・リンクが表示される' do
          expect(page).to have_content 'Friends'
          expect(page).to have_button 'Search'
          friends_link = find_all('a')[22]
          expect(friends_link.native.inner_text).to match(/Search/i)
        end
        it 'Postsヘディング・リンクが表示される' do
          expect(page).to have_content 'Posts'
          post_link = find_all('a')[23]
          expect(post_link.native.inner_text).to match(/See all posts/i)
        end
        it 'プロフィールへ正しく遷移する' do
          click_link 'Profile'
          expect(current_path).to eq user_path(user)
        end
        it 'プロフィール編集へ正しく遷移する' do
          click_link 'Edit profile'
          expect(current_path).to eq edit_user_path(user)
        end
      end
    end
    describe '退会のテスト' do
      before do
        sign_in user
        visit edit_user_path(user)
      end
      context '退会確認・処理のテスト' do
        it '退会をやめる' do
          click_link 'Delete account'
          expect(current_path).to eq user_confirm_path(user)
          click_link 'Back'
          expect(current_path).to eq user_path(user)
        end
        it '退会し、再ログインに失敗する' do
          click_link 'Delete account'
          expect(current_path).to eq user_confirm_path(user)
          click_link 'Delete account'
          expect(current_path).to eq root_path
          click_link 'Log in'
          fill_in 'user[email]', with: user.email
          fill_in 'user[password]', with: user.password
          click_button 'Log in'
          expect(current_path).to eq new_user_registration_path
        end
      end
    end
    describe 'ログインのテスト' do
      before do
        visit new_user_session_path
      end
      context 'ログイン処理の確認' do
        it 'ログインに失敗する' do
          click_button 'Log in'
          expect(page).to have_content 'Invalid'
        end
        it 'ログインに成功する' do
          fill_in 'user[email]', with: user.email
          fill_in 'user[password]', with: user.password
        end
      end
    end
  end
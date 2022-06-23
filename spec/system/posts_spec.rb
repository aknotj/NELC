# frozen_string_literal: true

require 'rails_helper'

  describe '投稿のテスト' do
    let(:user) {FactoryBot.create(:user)}
    let(:post) {create(:post, user_id: user.id)}
    before do
      sign_in user
    end
    describe '新規投稿のテスト' do
      before do
        visit new_post_path
      end
      context '表示の確認' do
        it 'URLが正しいか' do
          expect(current_path).to eq('/posts/new')
        end
        it 'フォームが表示されているか' do
          expect(page).to have_field 'post[title]'
          expect(page).to have_field 'post[body]'
          expect(page).to have_field 'post[name]'
          expect(page).to have_field 'post[language]'
          expect(page).to have_checked_field 'post_is_published_false'
          expect(page).to have_field 'post_is_published_true'
          expect(page).to have_button 'Submit'
        end
      end
      context '投稿動作の確認' do
        it '投稿に失敗する' do
          click_button 'Submit'
          expect(page).to have_content 'be blank'
        end
        it '下書き投稿に成功する' do
          fill_in 'post[title]', with: Faker::Lorem.characters(number:5)
          fill_in 'post[body]', with: Faker::Lorem.characters(number:5)
          click_button 'Submit'
          expect(current_path).to eq posts_drafts_path
        end
        it '投稿に成功する' do
          fill_in 'post[title]', with: Faker::Lorem.characters(number:5)
          fill_in 'post[body]', with: Faker::Lorem.characters(number:5)
          choose 'post_is_published_true'
          click_button 'Submit'
          expect(page).to have_current_path post_path(Post.last)
        end
      end
    end
    describe 'ユーザー投稿一覧のテスト' do
      before do
        visit user_posts_path(user)
      end
      context '表示の確認' do
        it 'URLが正しいか' do
          expect(current_path).to eq('/users/1/posts')
        end
        it 'Postの内容が表示されているか' do
          (1..5).each do |i|
            p = Post.create(title: 'hoge'+i.to_s, body: 'body'+i.to_s)
            c = Category.create(name: 'category'+i.to_s)
            PostCategory.create(post_id: p.id, category_id: c.id)
          end
          visit user_posts_path(user)
          Post.all.each_with_index do |post, i|
            expect(page).to have_content post.title
            expect(page).to have_content post.body
            expect(page).to have_content post.created_at
            expect(page).to have_content post.user.name
            post_link = find_all('a')[17+i]
            expect(post_link.native.inner_text).to match(/hoge/i)
            expect(post_link[:href]).to eq post_path(post)
            category_link = find_all('a')[28]
            expect(category_link.native.inner_text).to match(/category/i)
          end
          expect(page).to have_content "Latest Posts"
          expect(page).to have_content "Categories"
        end
      end
    end
    describe '投稿編集画面のテスト' do
      before do
        visit post_path(post)
      end
      context '表示の確認' do
        it 'editリンクが表示される' do
          edit_link = find_all('a')[20]
          expect(edit_link.native.inner_text).to match(/Edit/i)
        end
        it '投稿編集ページへ正しく遷移する' do
          click_link 'Edit'
          expect(page).to have_current_path edit_post_path(post)
          expect(page).to have_field 'post[title]'
          expect(page).to have_field 'post[body]'
          expect(page).to have_field 'post[name]'
          expect(page).to have_field 'post[language]'
          expect(page).to have_checked_field 'post_is_published_false'
          expect(page).to have_field 'post_is_published_true'
          expect(page).to have_button 'Submit'
        end
      end
    end
    describe '投稿編集機能のテスト' do
      before do 
        visit edit_post_path(post)
      end
      context '投稿編集機能の確認' do
        it 'URLが正しい' do
          expect(page).to have_current_path edit_post_path(post)
        end
        it '更新に失敗する' do
          fill_in 'post[title]', with: nil
          fill_in 'post[body]', with: nil
          click_button 'Submit'
          expect(page).to have_content 'be blank'
        end
        it '更新に成功する' do
          choose 'post_is_published_true'
          click_button 'Submit'
          expect(page).to have_current_path post_path(post)
        end
      end
      context '投稿削除機能の確認' do
        it '削除ボタンが表示されている' do
          expect(page).to have_link "Delete post 削除"
        end
        it 'application.html.erbにjavascript_pack_tagを含んでいる' do
          is_exist = 0
          open("app/views/layouts/application.html.erb").each do |line|
            strip_line = line.chomp.gsub(" ", "")
            if strip_line.include?("<%=javascript_pack_tag'application','data-turbolinks-track':'reload'%>")
              is_exist = 1
              break
            end
          end
          expect(is_exist).to eq(1)
        end
        it '正しく削除される' do
          click_link 'Delete post 削除'
          expect(Post.where(id: post.id).count).to eq 0
          expect(page).to have_current_path user_posts_path(user)
        end
      end
    end
  end
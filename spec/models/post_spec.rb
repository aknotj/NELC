# frozen_string_literal: true

require 'rails_helper'

describe 'Postモデルのテスト' do
  it "有効な投稿内容の場合は保存されるか" do
    expect(Post.reflect_on_association(:user).macro).to eq :belongs_to
    expect(FactoryBot.create(:post)).to be_valid
  end
end
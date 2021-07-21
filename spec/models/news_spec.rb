# frozen_string_literal: true

require 'rails_helper'

RSpec.describe News, 'Newsモデルに関するテスト', type: :model do

  describe '実際に保存してみる' do
      it '有効な内容の場合は保存されるか' do
        expect(FactoryBot.build(:news)).to be_valid
      end
  end

  describe 'バリデーションチェック' do
    context 'bodyカラム' do
      it '空白の場合に空白のエラーメッセージが返ってきているか' do
        news = News.new(body: '')
        expect(news).to be_invalid
        expect(news.errors[:body]).to include("を入力してください")
      end
    end
  end

end
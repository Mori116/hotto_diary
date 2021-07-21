# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Diary, "Diaryモデルに関するテスト", type: :model do

  let(:user) { FactoryBot.create(:user) }
  let(:group) { FactoryBot.create(:group) }
  let(:diary) { FactoryBot.build(:diary, user: user, group: group) }

  describe '実際に保存してみる' do
      it '有効な投稿内容の場合は保存されるか' do
        expect(diary).to be_valid
      end
  end

  describe 'バリデーションチェック' do
    context 'titleカラム' do
      it '空白の場合に空白のエラーメッセージが返ってきているか' do
        diary = Diary.new(title: "", body: "hoge")
        expect(diary).to be_invalid
        expect(diary.errors[:title]).to include("を入力してください")
      end
    end
    context 'bodyカラム' do
      it '空白の場合に空白のエラーメッセージが返ってきているか' do
        diary = Diary.new(title: "hoge", body: "")
        expect(diary).to be_invalid
        expect(diary.errors[:body]).to include("を入力してください")
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(described_class.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Groupモデルとの関係' do
      it 'N:1となっている' do
        expect(described_class.reflect_on_association(:group).macro).to eq :belongs_to
      end
    end
    context 'Notificationモデルとの関係' do
      it '1:Nとなっている' do
        expect(described_class.reflect_on_association(:notifications).macro).to eq :has_many
      end
    end
    context 'DiaryCommentモデルとの関係' do
      it '1:Nとなっている' do
        expect(described_class.reflect_on_association(:diary_comments).macro).to eq :has_many
      end
    end
  end

end
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DiaryComment, 'DiaryCommentモデルに関するテスト', type: :model do

  let(:user) { FactoryBot.create(:user) }
  let(:group) { FactoryBot.create(:group) }
  let(:diary) { FactoryBot.create(:diary, user: user, group: group) }
  let(:diary_comment) { FactoryBot.build(:diary_comment, user: user, diary: diary) }


  describe '実際に保存してみる' do
      it '有効な内容の場合は保存されるか' do
        expect(diary_comment).to be_valid
      end
  end

  describe 'バリデーションチェック' do
    context 'commentカラム' do
      it '空白の場合に空白のエラーメッセージが返ってきているか' do
        diary_comment.comment = ""
        expect(diary_comment).to be_invalid
        expect(diary_comment.errors[:comment]).to include("を入力してください")
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(described_class.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Diaryモデルとの関係' do
      it 'N:1となっている' do
        expect(described_class.reflect_on_association(:diary).macro).to eq :belongs_to
      end
    end
    context 'Notificationモデルとの関係' do
      it '1:Nとなっている' do
        expect(described_class.reflect_on_association(:notifications).macro).to eq :has_many
      end
    end
  end

end
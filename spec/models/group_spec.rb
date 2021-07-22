# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, 'Groupモデルに関するテスト', type: :model do

  let(:group) { FactoryBot.build(:group) }

  describe '実際に保存してみる' do
      it '有効な投稿内容の場合は保存されるか' do
        expect(group).to be_valid
      end
  end

  describe 'バリデーションチェック' do
    context 'nameカラム' do
      it '空白の場合に空白のエラーメッセージが返ってきているか' do
        group = Group.new(name: "", password: "password", password_confirmation: "password")
        expect(group).to be_invalid
        expect(group.errors[:name]).to include("を入力してください")
      end
    end

    context 'passwordカラム' do
      it '空白の場合に空白のエラーメッセージが返ってきているか' do
        group = Group.new(name: "hoge", password: "", password_confirmation: "password")
        expect(group).to be_invalid
        expect(group.errors[:password]).to include("を入力してください")
      end
      it '6文字以下の場合にエラーメッセージが返ってきているか' do
        group = build(:group, password: "00000", password_confirmation: "00000")
        expect(group).to be_invalid
        expect(group.errors[:password]).to include("は6文字以上で入力してください")
      end
    end

    context 'password_confirmationカラム' do
      it 'パスワードが入力されていても、本カラムが空白の場合にエラーメッセージが返ってきているか' do
        group = build(:group, password: "password", password_confirmation: "")
        expect(group).to be_invalid
        expect(group.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it '多対多のため、中間テーブルを利用し1対Nとなっている' do
        expect(described_class.reflect_on_association(:group_users).macro).to eq :has_many
        expect(described_class.reflect_on_association(:users).macro).to eq :has_many
      end
    end

    context 'Diaryモデルとの関係' do
      it '1:Nとなっている' do
        expect(described_class.reflect_on_association(:diaries).macro).to eq :has_many
      end
    end
  end

end
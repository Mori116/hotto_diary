# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, 'Userモデルに関するテスト', type: :model do
  describe 'バリデーションチェック' do
    subject { user.valid? }

    let!(:other_user) { create(:user) }
    let(:user) { build(:user) }

    context 'last_nameカラム' do
      it '空白の場合にエラーメッセージが返ってきているか' do
        user = User.new(last_name: "", first_name: "太郎", last_name_kana: "タナカ",
                        first_name_kana: "タロウ", email: "a@a", nickname: "タロー",
                        is_deleted: false, password: "password", password_confirmation: "password")
        expect(user).to be_invalid
        expect(user.errors[:last_name]).to include("を入力してください")
      end
    end

    context 'first_nameカラム' do
      it '空白の場合にエラーメッセージが返ってきているか' do
        user = User.new(last_name: "田中", first_name: "", last_name_kana: "タナカ",
                        first_name_kana: "タロウ", email: "a@a", nickname: "タロー",
                        is_deleted: false, password: "password", password_confirmation: "password")
        expect(user).to be_invalid
        expect(user.errors[:first_name]).to include("を入力してください")
      end
    end

    context 'last_name_kanaカラム' do
      it '空白の場合にエラーメッセージが返ってきているか' do
        user = User.new(last_name: "田中", first_name: "太郎", last_name_kana: "",
                        first_name_kana: "タロウ", email: "a@a", nickname: "タロー",
                        is_deleted: false, password: "password", password_confirmation: "password")
        expect(user).to be_invalid
        expect(user.errors[:last_name_kana]).to include("を入力してください")
      end
      it 'カタカナであること' do
        user = build(:user, last_name_kana: 'kana')
        expect(user).to be_invalid
        expect(user.errors[:last_name_kana]).to include("は不正な値です")
      end
    end

    context 'first_name_kanaカラム' do
      it '空白の場合にエラーメッセージが返ってきているか' do
        user = User.new(last_name: "田中", first_name: "太郎", last_name_kana: "タナカ",
                        first_name_kana: "", email: "a@a", nickname: "タロー",
                        is_deleted: false, password: "password", password_confirmation: "password")
        expect(user).to be_invalid
        expect(user.errors[:first_name_kana]).to include("を入力してください")
      end
      it 'カタカナでない場合にエラーメッセージが返ってきているか' do
        user = build(:user, first_name_kana: 'kana')
        expect(user).to be_invalid
        expect(user.errors[:first_name_kana]).to include("は不正な値です")
      end
    end

    context 'nicknameカラム' do
      it '空白の場合にエラーメッセージが返ってきているか' do
        user = User.new(last_name: "田中", first_name: "太郎", last_name_kana: "タナカ",
                        first_name_kana: "タロウ", email: "a@a", nickname: "",
                        is_deleted: false, password: "password", password_confirmation: "password")
        expect(user).to be_invalid
        expect(user.errors[:nickname]).to include("を入力してください")
      end
    end

    context 'emailカラム' do
      it '空白の場合にエラーメッセージが返ってきているか' do
        user = User.new(last_name: "田中", first_name: "太郎", last_name_kana: "タナカ",
                        first_name_kana: "タロウ", email: "", nickname: "タロー",
                        is_deleted: false, password: "password", password_confirmation: "password")
        expect(user).to be_invalid
        expect(user.errors[:email]).to include("を入力してください")
      end
      it '一意性があること' do
        user.email = other_user.email
        is_expected.to eq false
      end
    end

    context 'passwordカラム' do
      it '空白の場合にエラーメッセージが返ってきているか' do
        user = User.new(last_name: "田中", first_name: "太郎", last_name_kana: "タナカ",
                        first_name_kana: "タロウ", email: "a@a", nickname: "タロー",
                        is_deleted: false, password: "", password_confirmation: "password")
        expect(user).to be_invalid
        expect(user.errors[:password]).to include("を入力してください")
      end
    end

    context 'password_confirmationカラム' do
      it 'パスワードが入力されていても、本カラムが空白の場合にエラーメッセージが返ってきているか' do
        user = build(:user, password: '000000', password_confirmation: '')
        expect(user).to be_invalid
        expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
      end
    end
  end


  describe 'アソシエーションのテスト' do
    context 'Diaryモデルとの関係' do
      it '1:Nとなっている' do
        expect(described_class.reflect_on_association(:diaries).macro).to eq :has_many
      end
    end

    context 'DiaryCommentモデルとの関係' do
      it '1:Nとなっている' do
        expect(described_class.reflect_on_association(:diary_comments).macro).to eq :has_many
      end
    end

    context 'Groupモデルとの関係' do
      it '多対多のため、中間テーブルを利用し1対Nとなっている' do
        expect(described_class.reflect_on_association(:group_users).macro).to eq :has_many
        expect(described_class.reflect_on_association(:groups).macro).to eq :has_many
      end
    end

    context 'Notificationモデルとの関係' do
      it '1:Nとなっている' do
        expect(described_class.reflect_on_association(:active_notifications).macro).to eq :has_many
        expect(described_class.reflect_on_association(:passive_notifications).macro).to eq :has_many
      end
    end
  end

end
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin, 'Adminモデルに関するテスト', type: :model do
  describe 'バリデーションチェック' do
    subject { admin.valid? }

    let!(:other_admin) { create(:admin) }
    let(:admin) { build(:admin) }

    context 'emailカラム' do
      it '空白の場合にエラーメッセージが返ってきているか' do
        admin = Admin.new(email: "", password: "password", password_confirmation: "password")
        expect(admin).to be_invalid
        expect(admin.errors[:email]).to include("を入力してください")
      end
      it '一意性があること' do
        admin.email = other_admin.email
        is_expected.to eq false
      end
    end

    context 'passwordカラム' do
      it '空白の場合にエラーメッセージが返ってきているか' do
        admin = Admin.new(email: "a@a", password: "", password_confirmation: "password")
        expect(admin).to be_invalid
        expect(admin.errors[:password]).to include("を入力してください")
      end
    end

    context 'password_confirmationカラム' do
      it 'パスワードが入力されていても、本カラムが空白の場合にエラーメッセージが返ってきているか' do
        admin = Admin.new(email: "a@a", password: "password", password_confirmation: "")
        expect(admin).to be_invalid
        expect(admin.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
      end
    end
  end

end
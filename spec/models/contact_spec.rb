# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact, 'Contactモデルに関するテスト', type: :model do

  let(:contact) { FactoryBot.build(:contact) }

  describe '実際に保存してみる' do
      it '有効な投稿内容の場合は保存されるか' do
        expect(contact).to be_valid
      end
  end

  describe 'バリデーションチェック' do
    context 'nameカラム' do
      it '空白の場合に空白のエラーメッセージが返ってきているか' do
        contact = Contact.new(name: "", email: "a@a", message: "hoge")
        expect(contact).to be_invalid
        expect(contact.errors[:name]).to include("を入力してください")
      end
    end
    context 'emailカラム' do
      it '空白の場合に空白のエラーメッセージが返ってきているか' do
        contact = Contact.new(name: "たろう", email: "", message: "hoge")
        expect(contact).to be_invalid
        expect(contact.errors[:email]).to include("を入力してください")
      end
    end
    context 'messageカラム' do
      it '空白の場合に空白のエラーメッセージが返ってきているか' do
        contact = Contact.new(name: "たろう", email: "a@a", message: "")
        expect(contact).to be_invalid
        expect(contact.errors[:message]).to include("を入力してください")
      end
    end
  end

end
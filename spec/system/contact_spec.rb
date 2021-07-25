# frozen_string_literal: true

require 'rails_helper'

describe '問い合わせのテスト' do
  let(:contact) { create(:contact) }

  describe '問い合わせフォーム画面のテスト' do
    before do
      visit new_contact_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/contacts/new'
      end
      it '「問い合わせ」と表示される' do
        expect(page).to have_content '問い合わせ'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'contact[name]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'contact[email]'
      end
      it 'messageフォームが表示される' do
        expect(page).to have_field 'contact[message]'
      end
      it '送信するボタンが表示される' do
        expect(page).to have_button '送信する'
      end
    end

    context '送信成功のテスト' do
      before do
        visit new_contact_path
        fill_in 'contact[name]', with: contact.name
        fill_in 'contact[email]', with: contact.email
        fill_in 'contact[message]', with: contact.message
      end

      it '自分の問い合わせ情報が正しく保存される' do
        expect { click_button '送信する' }.to change(Contact.all, :count).by(1)
      end
      it 'リダイレクト先が、送信完了画面になっている' do
        click_button '送信する'
        expect(current_path).to eq '/contacts/complete'
      end
    end
  end

end
# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
      # 以降、ログイン前の画面共通化（トップ画面のテスト内）
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it 'Log inリンクが表示される: 左上から4番目のリンクが「Log in」である' do
        log_in_link = find_all('a')[4].native.inner_text
        expect(log_in_link).to match("ログインする")
      end
      it 'Log inリンクの内容が正しい' do
        log_in_link = find_all('a')[4].native.inner_text
        expect(page).to have_link log_in_link, href: new_user_session_path
      end
      it 'Sign Upリンクが表示される: 左上から5番目のリンクが「Sign Up」である' do
        sign_up_link = find_all('a')[5].native.inner_text
        expect(sign_up_link).to match("新規登録する")
      end
      it 'Sign Upリンクの内容が正しい' do
        sign_up_link = find_all('a')[5].native.inner_text
        expect(page).to have_link sign_up_link, href: new_user_registration_path
      end
    end
  end

  describe 'アバウト画面のテスト' do
    before do
      visit '/homes/about'
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/homes/about'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'Aboutリンクが表示される: 左上から1番目のリンクが「About」である' do
        about_link = find_all('a')[1].native.inner_text
        expect(about_link).to match("ほっとダイアリーとは")
      end
      it 'sign upリンクが表示される: 左上から2番目のリンクが「sign up」である' do
        signup_link = find_all('a')[2].native.inner_text
        expect(signup_link).to match("新規登録")
      end
      it 'loginリンクが表示される: 左上から3番目のリンクが「login」である' do
        login_link = find_all('a')[3].native.inner_text
        expect(login_link).to match("ログイン")
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it 'Top(ロゴ)を押すと、トップ画面に遷移する' do
        click_on 'Hotto diary'
        is_expected.to eq '/'
      end
      it 'ほっとダイアリーとはを押すと、アバウト画面に遷移する' do
        about_link = find_all('a')[1].native.inner_text
        about_link = about_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link about_link
        is_expected.to eq '/homes/about'
      end
      it '新規登録を押すと、新規登録画面に遷移する' do
        signup_link = find_all('a')[2].native.inner_text
        signup_link = signup_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link signup_link
        is_expected.to eq '/users/sign_up'
      end
      it 'ログインを押すと、ログイン画面に遷移する' do
        login_link = find_all('a')[3].native.inner_text
        login_link = login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link login_link
        is_expected.to eq '/users/sign_in'
      end
    end
  end

  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '「新規登録」と表示される' do
        expect(page).to have_content '新規登録'
      end
      it 'last_nameフォームが表示される' do
        expect(page).to have_field 'user[last_name]'
      end
      it 'first_nameフォームが表示される' do
        expect(page).to have_field 'user[first_name]'
      end
      it 'last_name_kanaフォームが表示される' do
        expect(page).to have_field 'user[last_name_kana]'
      end
      it 'first_name_kanaフォームが表示される' do
        expect(page).to have_field 'user[first_name_kana]'
      end
      it 'nicknameフォームが表示される' do
        expect(page).to have_field 'user[nickname]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it '新規登録ボタンが表示される' do
        expect(page).to have_button '新規登録'
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it '「こちら」を押すと、ログイン画面に遷移する' do
        click_link 'こちら'
        is_expected.to eq '/users/sign_in'
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'user[last_name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[first_name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[last_name_kana]', with: 'タナカ'
        fill_in 'user[first_name_kana]', with: 'タロウ'
        fill_in 'user[nickname]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '正しく新規登録される' do
        expect { click_button '新規登録' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録できたユーザの詳細画面(マイページ)になっている' do
        click_button '新規登録'
        expect(current_path).to eq '/users/' + User.last.id.to_s
      end
    end
  end

  describe 'ユーザログイン' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it '「ログイン」と表示される' do
        expect(page).to have_content 'ログイン'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'ログインボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
      it '新規登録ページへのリンク「こちら」が表示される' do
        expect(page).to have_content 'こちら'
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it '「こちら」を押すと、新規登録画面に遷移する' do
        click_link 'こちら'
        is_expected.to eq '/users/sign_up'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先が、ログインしたユーザの詳細画面(マイページ)になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end
end

describe 'ユーザログアウトのテスト' do
  let(:user) { create(:user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
    logout_link = find_all('a')[4].native.inner_text
    logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
    click_link logout_link
  end

  context 'ログアウト機能のテスト' do
    it '正しくログアウトできている: ログアウト後のリダイレクト先においてAbout画面へのリンクが存在する' do
      expect(page).to have_link '', href: '/homes/about'
    end
    it 'ログアウト後のリダイレクト先が、トップになっている' do
      expect(current_path).to eq '/'
    end
  end
end
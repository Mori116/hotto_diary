# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザのテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:group) { create(:group) }
  let!(:diary) { create(:diary, user: user, group: group) }
  let!(:diary_comment) { create(:diary_comment, diary: diary, user: other_user) }
  let!(:notification) { create(:notification, visitor: other_user, visited: user, diary: diary, diary_comment: diary_comment) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  describe 'マイページ画面のテスト' do
    before do
      visit user_path(user)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      it '「登録情報」が表示される' do
        expect(page).to have_content '登録情報'
        expect(page).to have_content user.full_name
        expect(page).to have_content user.last_name_kana + user.first_name_kana
        expect(page).to have_content user.nickname
        expect(page).to have_content user.email
      end
      it '「通知一覧」が表示される' do
        expect(page).to have_content '通知一覧'
        expect(page).to have_content other_user.nickname + 'があなたの日記にコメントしました'
        expect(page).to have_link '全削除'
      end
      it '「編集する」ボタンが表示される' do
        expect(page).to have_link "編集する"
      end
      it '「交換日記へ」ボタンが表示される' do
        expect(page).to have_link "交換日記へ"
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it '「編集する」を押すと、ユーザ編集画面に遷移する' do
        click_link '編集する'
        is_expected.to eq '/users/' + user.id.to_s + '/edit'
      end
      it '「交換日記へ」を押すと、所属グループ一覧画面に遷移する' do
        click_link '交換日記へ'
        is_expected.to eq '/users/' + user.id.to_s + '/join_groups'
      end
    end

    context '通知の全削除テスト' do
      before do
        click_link '全削除'
      end

      it '正しく削除される' do
        expect(Notification.all.count).to eq 0
      end
      it 'リダイレクト先が、マイページ画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end

  describe '自分のユーザ情報編集画面のテスト' do
    before do
      visit edit_user_path(user)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
      end
      it '「ユーザ情報編集」と表示される' do
        expect(page).to have_content 'ユーザ情報編集'
      end
      it 'last_nameフォームが表示される' do
        expect(page).to have_field 'user[last_name]', with: user.last_name
      end
      it 'first_nameフォームが表示される' do
        expect(page).to have_field 'user[first_name]', with: user.first_name
      end
      it 'last_name_kanaフォームが表示される' do
        expect(page).to have_field 'user[last_name_kana]', with: user.last_name_kana
      end
      it 'first_name_kanaフォームが表示される' do
        expect(page).to have_field 'user[first_name_kana]', with: user.first_name_kana
      end
      it 'nicknameフォームが表示される' do
        expect(page).to have_field 'user[nickname]', with: user.nickname
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]', with: user.email
      end
      it '変更内容を保存するボタンが表示される' do
        expect(page).to have_button '変更内容を保存する'
      end
      it '退会するリンクが表示される' do
        expect(page).to have_link '退会する', href: quit_user_path(user)
      end
      it 'マイページへ戻るリンクが表示される' do
        expect(page).to have_link 'マイページへ戻る', href: user_path(user)
      end
    end

    context '編集成功のテスト' do
      before do
        @user_old_last_name = user.last_name
        @user_old_first_name = user.first_name
        @user_old_last_name_kana = user.last_name_kana
        @user_old_first_name_kana = user.first_name_kana
        @user_old_nickname = user.nickname
        @user_old_email = user.email
        fill_in 'user[last_name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[first_name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[last_name_kana]', with: "サトウ"
        fill_in 'user[first_name_kana]', with: "ハナコ"
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[nickname]', with: Faker::Lorem.characters(number: 10)
        click_button '変更内容を保存する'
      end

      it 'last_name,first_nameが正しく更新される' do
        expect(user.reload.last_name).not_to eq @user_old_last_name
        expect(user.reload.first_name).not_to eq @user_old_first_name
      end
      it 'last_name_kana,first_name_kanaが正しく更新される' do
        expect(user.reload.last_name_kana).not_to eq @user_old_last_name_kana
        expect(user.reload.first_name_kana).not_to eq @user_old_first_name_kana
      end
      it 'nicknameが正しく更新される' do
        expect(user.reload.nickname).not_to eq @user_old_nickname
      end
      it 'emailが正しく更新される' do
        expect(user.reload.email).not_to eq @user_old_email
      end
      it 'リダイレクト先が、マイページ画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
        expect(page).to have_content 'マイページ'
      end
    end
  end

  describe '自分の退会確認画面のテスト' do
    before do
      visit quit_user_path(user)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/quit'
      end
      it '退会するリンクが表示される' do
        expect(page).to have_link '退会する', href: withdraw_user_path(user)
      end
      it '退会しないリンクが表示される' do
        expect(page).to have_link '退会しない', href: user_path(user)
      end
    end

    context '退会のテスト' do
      before do
        click_link '退会する'
      end

      it '正しく退会処理される' do
        expect(user.reload.is_deleted).to eq true
      end
      it 'リダイレクト先が、Top画面になっている' do
        expect(current_path).to eq '/'
      end
    end
  end

end
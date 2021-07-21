# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザログイン後のテスト' do
  let(:user) { create(:user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end

  describe 'ヘッダーのテスト: ログインしている場合' do

    context '表示内容の確認' do
      it 'マイページリンクが表示される: 左上から1番目のリンクが「マイページ」である' do
        user_link = find_all('a')[1].native.inner_text
        expect(user_link).to match("マイページ")
      end
      it '交換日記リンクが表示される: 左上から2番目のリンクが「交換日記(所属グループ一覧)」である' do
        join_groups_link = find_all('a')[2].native.inner_text
        expect(join_groups_link).to match("交換日記")
      end
      it 'グループ検索リンクが表示される: 左上から3番目のリンクが「グループ検索」である' do
        search_group_link = find_all('a')[3].native.inner_text
        expect(search_group_link).to match("グループ検索")
      end
      it 'ログアウトリンクが表示される: 左上から3番目のリンクが「ログアウト」である' do
        logout_link = find_all('a')[4].native.inner_text
        expect(logout_link).to match("ログアウト")
      end
    end

    context 'リンクの内容を確認: ※logoutは01_before_login_spec.rbの『ユーザログアウトのテスト』でテスト済み。' do
      subject { current_path }

      it 'Top(ロゴ)を押すと、Top画面に遷移する' do
        click_on 'Hotto diary'
        is_expected.to eq '/'
      end
      it 'マイページを押すと、自分のユーザ詳細画面に遷移する' do
        user_link = find_all('a')[1].native.inner_text
        user_link = user_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link user_link
        is_expected.to eq '/users/' + user.id.to_s
      end
      it '交換日記を押すと、所属グループ一覧画面に遷移する' do
        join_groups_link = find_all('a')[2].native.inner_text
        join_groups_link = join_groups_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link join_groups_link
        is_expected.to eq '/users/' + user.id.to_s + '/join_groups'
      end
      it 'グループ検索を押すと、グループ検索画面に遷移する' do
        search_group_link = find_all('a')[3].native.inner_text
        search_group_link = search_group_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link search_group_link
        is_expected.to eq '/groups'
      end
    end
  end
end
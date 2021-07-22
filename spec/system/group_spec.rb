# frozen_string_literal: true

require 'rails_helper'

describe 'グループのテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:true_user) { create(:user, is_deleted: true) }
  let!(:group) { create(:group, owner_id: user.id) }
  let!(:other_group) { create(:group, owner_id: other_user.id) }
  let!(:true_owner_group) { create(:group, owner_id: true_user.id) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'

    visit join_group_path(group)
    fill_in 'group[password]', with: group.password
    click_button '参加する'

    visit join_group_path(other_group)
    fill_in 'group[password]', with: other_group.password
    click_button '参加する'
  end

  describe 'グループ一覧画面のテスト' do
    before do
      visit groups_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/groups'
      end
      it '「グループ検索」が表示される' do
        expect(page).to have_content 'グループ検索'
      end
      it '検索フォームが表示される' do
        expect(page).to have_button '検索'
      end
      it '「全グループ一覧」が表示される' do
        expect(page).to have_content '全グループ一覧'
        expect(page).to have_content group.name
        expect(page).to have_content group.users.size
      end
      it '「グループを新規作成する」が表示される' do
        expect(page).to have_link 'グループを新規作成する'
      end
      it '自分が作成者のグループと他人が作成者のグループの名前が表示される' do
        expect(page).to have_content group.name
        expect(page).to have_content other_group.name
      end
      it 'グループ作成者が退会済の場合、グループは表示されない' do
        expect(page).not_to have_content true_owner_group.name
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it '「グループを新規作成する」を押すと、グループの新規作成画面に遷移する' do
        click_link 'グループを新規作成する'
        is_expected.to eq '/groups/new'
      end
      it '自分が作成者のグループと他人が作成者のグループの「詳細へ」のリンク先がそれぞれ正しい' do
        expect(page).to have_link '詳細へ', href: group_path(group)
        expect(page).to have_link '詳細へ', href: group_path(other_group)
      end
    end
  end

  describe 'グループ新規作成画面のテスト' do
    before do
      visit new_group_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/groups/new'
      end
      it '「グループ作成」と表示される' do
        expect(page).to have_content 'グループ作成'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'group[name]'
      end
      it 'imageフォームが表示される' do
        expect(page).to have_field 'group[image]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'group[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'group[password_confirmation]'
      end
      it '作成するボタンが表示される' do
        expect(page).to have_button '作成する'
      end
      it '戻るリンクが表示される' do
        expect(page).to have_link '戻る'
      end
    end

    context '作成成功のテスト' do
      before do
        visit new_group_path
        fill_in 'group[name]', with: group.name
        fill_in 'group[password]', with: group.password
        fill_in 'group[password_confirmation]', with: group.password_confirmation
      end

      it '自分のグループが正しく保存される' do
        expect { click_button '作成する' }.to change(user.groups, :count).by(1)
      end
      it 'リダイレクト先が、日記詳細画面になっている' do
        click_button '作成する'
        expect(current_path).to eq '/groups/' + Group.last.id.to_s
      end
    end
  end

  describe '自分が作成者のグループ詳細画面のテスト' do
    before do
      visit group_path(group)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/groups/' + group.id.to_s
      end
      it 'nameが表示される' do
        expect(page).to have_content group.name
      end
      it '参加人数が表示される' do
        expect(page).to have_content group.users.size
      end
      it 'ownerが表示される' do
        expect(page).to have_content group.owner.nickname
      end
      it '編集するリンクが表示される' do
        expect(page).to have_link '編集する', href: edit_group_path(group)
      end
      it '交換日記へリンクが表示される' do
        expect(page).to have_link '交換日記へ', href: group_diaries_path(group)
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it '「編集する」を押すと、グループの編集画面に遷移する' do
        click_link '編集する'
        is_expected.to eq '/groups/' + group.id.to_s + '/edit'
      end
      it '「交換日記へ」を押すと、グループの編集画面に遷移する' do
        click_link '交換日記へ'
        is_expected.to eq '/groups/' + group.id.to_s + '/diaries'
      end
    end
  end

  describe '自分が作成者のグループ編集画面のテスト' do
    before do
      visit edit_group_path(group)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/groups/' + group.id.to_s + '/edit'
      end
      it '「グループ編集」と表示される' do
        expect(page).to have_content 'グループ編集'
      end
      it 'name編集フォームが表示される' do
        expect(page).to have_field 'group[name]', with: group.name
      end
      it '変更内容を保存するボタンが表示される' do
        expect(page).to have_button '変更内容を保存する'
      end
      it '戻るリンクが表示される' do
        expect(page).to have_link '戻る'
      end
      it '削除するリンクが表示される' do
        expect(page).to have_link '削除する', href: group_path(group)
      end
    end

    context '編集成功のテスト' do
      before do
        @group_old_name = group.name
        fill_in 'group[name]', with: Faker::Lorem.characters(number: 10)
        click_button '変更内容を保存する'
      end

      it 'nameが正しく更新される' do
        expect(group.reload.name).not_to eq @group_old_name
      end
      it 'リダイレクト先が、グループ詳細画面になっている' do
        expect(current_path).to eq '/groups/' + group.id.to_s
        expect(page).to have_content 'グループ詳細'
      end
    end

    context '削除リンクのテスト' do
      before do
        click_link '削除する'
      end

      it '正しく削除される' do
        expect(Group.where(id: group.id).count).to eq 0
      end
      it 'リダイレクト先が、グループ一覧画面になっている' do
        expect(current_path).to eq '/groups'
      end
    end
  end

  describe '他人が作成者のグループ詳細画面のテスト' do
    before do
      visit group_path(other_group)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/groups/' + other_group.id.to_s
      end
      it 'nameが表示される' do
        expect(page).to have_content other_group.name
      end
      it '参加人数が表示される' do
        expect(page).to have_content other_group.users.size
      end
      it 'ownerが表示される' do
        expect(page).to have_content other_group.owner.nickname
      end
      it '交換日記へリンクが表示される' do
        expect(page).to have_link '交換日記へ', href: group_diaries_path(other_group)
      end
      it '編集するリンクが表示されない' do
        expect(page).not_to have_link '編集する', href: edit_group_path(other_group)
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it '「交換日記へ」を押すと、グループの編集画面に遷移する' do
        click_link '交換日記へ'
        is_expected.to eq '/groups/' + other_group.id.to_s + '/diaries'
      end
    end
  end

  describe '自分の所属グループ一覧画面のテスト' do
    before do
      visit join_groups_user_path(user)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/join_groups'
      end
      it '「グループを新規作成する」リンクが表示される' do
        expect(page).to have_link 'グループを新規作成する', href: new_group_path
      end
      it 'グループ名が表示される' do
        expect(page).to have_content group.name
      end
      it '参加人数が表示される' do
        expect(page).to have_content group.users.size
      end
      it '参加メンバーが表示される' do
        expect(page).to have_content user.nickname
      end
      it '「交換日記へ」リンクが表示される' do
        expect(page).to have_link '交換日記へ', href: group_diaries_path(group)
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it '「グループを新規作成する」を押すと、グループの新規作成画面に遷移する' do
        click_link 'グループを新規作成する'
        is_expected.to eq '/groups/new'
      end
      it 'グループ名を押すと、グループの詳細画面に遷移する' do
        click_link group.name
        is_expected.to eq '/groups/' + group.id.to_s
      end
    end
  end

  describe 'グループ参加画面のテスト' do
    before do
      visit join_group_path(group)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/groups/' + group.id.to_s + '/join'
      end
      it '「グループのパスワードをご入力ください」と表示される' do
        expect(page).to have_content 'グループのパスワードをご入力ください'
      end
      it 'グループ名が表示される' do
        expect(page).to have_content group.name
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'group[password]'
      end
      it '参加するボタンが表示される' do
        expect(page).to have_button '参加する'
      end
    end

    context '参加するリンクのテスト' do
      before do
        visit join_group_path(group)
        fill_in 'group[password]', with: group.password
      end

      it '自分が正しく参加できる' do
        expect { click_button '参加する' }.to change(group.users, :count).by(1)
      end
      it 'リダイレクト先が、日記一覧画面になっている' do
        click_button '参加する'
        expect(current_path).to eq '/groups/' + group.id.to_s + '/diaries'
      end
    end
  end

end
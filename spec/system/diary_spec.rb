# frozen_string_literal: true

require 'rails_helper'

describe '交換日記のテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:true_user) { create(:user, is_deleted: true) }
  let!(:group) { create(:group, owner_id: user.id) }
  let!(:diary) { create(:diary, user: user, group: group) }
  let!(:other_diary) { create(:diary, user: other_user, group: group) }
  let!(:true_user_diary) { create(:diary, user: true_user, group: group) }
  # 同じグループでの交換日記

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'

    visit join_group_path(group)
    fill_in 'group[password]', with: group.password
    click_button '参加する'
  end

  describe '日記一覧画面のテスト' do
    before do
      visit group_diaries_path(group)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/groups/' + group.id.to_s + '/diaries'
      end
      it '「日記一覧」と表示される' do
        expect(page).to have_content '日記一覧'
      end
      it '「グループ名」が表示される' do
        expect(page).to have_content 'グループ名：' + group.name
      end
      it '「新規投稿する」ボタンが表示される' do
        expect(page).to have_link "新規投稿する"
      end
      it '自分の日記と他人の日記の「閲覧する」のリンク先がそれぞれ正しい' do
        expect(page).to have_link '閲覧する', href: group_diary_path(group, diary)
        expect(page).to have_link '閲覧する', href: group_diary_path(group, other_diary)
      end
      it '自分の日記と他人の日記のタイトルが表示される' do
        expect(page).to have_content diary.title
        expect(page).to have_content other_diary.title
      end
      it '自分と他人のニックネームが表示される' do
        expect(page).to have_content diary.user.nickname
        expect(page).to have_content other_diary.user.nickname
      end
      it '退会済のユーザの日記は表示されない' do
        expect(page).not_to have_content true_user_diary.title
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it '「新規投稿する」を押すと、日記の新規投稿画面に遷移する' do
        click_link '新規投稿する'
        is_expected.to eq '/groups/' + group.id.to_s + '/diaries/new'
      end
    end

    context '投稿成功のテスト' do
      before do
        visit new_group_diary_path(group)
        fill_in 'diary[title]', with: diary.title
        fill_in 'diary[body]', with: diary.body
        choose "diary_status_false"
      end

      it '自分の新しい日記が正しく保存される' do
        expect { click_button '作成する' }.to change(user.diaries, :count).by(1)
      end
      it 'リダイレクト先が、保存できた投稿の詳細画面になっている' do
        click_button '作成する'
        expect(current_path).to eq '/groups/' + group.id.to_s + '/diaries/' + Diary.last.id.to_s
      end
    end
  end

  describe '自分の日記詳細画面のテスト' do
    before do
      visit group_diary_path(group, diary)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/groups/' + group.id.to_s + '/diaries/' + diary.id.to_s
      end
      it '「日記詳細」と表示される' do
        expect(page).to have_content '日記詳細'
      end
      it '投稿画像が表示される' do
        expect(page).to have_content diary.image
      end
      it '日記のtitleが表示される' do
        expect(page).to have_content diary.title
      end
      it '日記のbodyが表示される' do
        expect(page).to have_content diary.body
      end
      it '日記の編集リンクが表示される' do
        expect(page).to have_link '編集する', href: edit_group_diary_path(group, diary)
      end
      it '日記の削除リンクが表示される' do
        expect(page).to have_link '削除する', href: group_diary_path(group, diary)
      end
      it '「日記一覧へ」リンクが表示される' do
        expect(page).to have_link '日記一覧へ', href: group_diaries_path(group)
      end
    end

    context 'コメントの確認' do
      it 'commentフォームが表示される' do
        expect(page).to have_field 'diary_comment[comment]'
      end
      it 'commentフォームに値が入っていない' do
        expect(find_field('diary_comment[comment]').text).to be_blank
      end
      it '「コメントする」ボタンが表示される' do
        expect(page).to have_button 'コメントする'
      end
    end

    context '編集リンクのテスト' do
      it '編集画面に遷移する' do
        click_link '編集する'
        expect(current_path).to eq '/groups/' + group.id.to_s + '/diaries/' + diary.id.to_s + '/edit'
      end
    end

    context '削除リンクのテスト' do
      before do
        click_link '削除する'
      end

      it '正しく削除される' do
        expect(Diary.where(id: diary.id).count).to eq 0
      end
      it 'リダイレクト先が、日記一覧画面になっている' do
        expect(current_path).to eq '/groups/' + group.id.to_s + '/diaries'
      end
    end
  end

  describe '自分の日記編集画面のテスト' do
    before do
      visit edit_group_diary_path(group, diary)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/groups/' + group.id.to_s + '/diaries/' + diary.id.to_s + '/edit'
      end
      it '「日記編集」と表示される' do
        expect(page).to have_content '日記編集'
      end
      it 'title編集フォームが表示される' do
        expect(page).to have_field 'diary[title]', with: diary.title
      end
      it 'body編集フォームが表示される' do
        expect(page).to have_field 'diary[body]', with: diary.body
      end
      it '公開/非公開のボタンが表示され、公開ボタン(デフォルト)が選択されている' do
        expect(page).to have_checked_field('diary_status_false')
      end
      it '変更内容を保存するボタンが表示される' do
        expect(page).to have_button '変更内容を保存する'
      end
      it '戻るリンクが表示される' do
        expect(page).to have_link '戻る'
      end
    end

    context '編集成功のテスト' do
      before do
        @diary_old_title = diary.title
        @diary_old_body = diary.body
        @diary_old_status = diary.status
        fill_in 'diary[title]', with: Faker::Lorem.characters(number: 5)
        fill_in 'diary[body]', with: Faker::Lorem.characters(number: 20)
        choose "diary_status_true"
        click_button '変更内容を保存する'
      end

      it 'titleが正しく更新される' do
        expect(diary.reload.title).not_to eq @diary_old_title
      end
      it 'bodyが正しく更新される' do
        expect(diary.reload.body).not_to eq @diary_old_body
      end
      it 'statusが正しく更新される' do
        expect(diary.reload.status).not_to eq @diary_old_status
      end
      it 'リダイレクト先が、更新した日記の詳細画面になっている' do
        expect(current_path).to eq '/groups/' + group.id.to_s + '/diaries/' + diary.id.to_s
        expect(page).to have_content '日記詳細'
      end
    end
  end

end
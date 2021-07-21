# frozen_string_literal: true

require 'rails_helper'

describe 'お知らせのテスト' do
  let(:admin) { create(:admin) }
  let!(:news) { create(:news) }

  before do
  visit new_admin_session_path
  fill_in 'admin[email]', with: admin.email
  fill_in 'admin[password]', with: admin.password
  click_button 'ログイン'
  end

  describe 'お知らせ一覧画面(Top画面)のテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it 'お知らせが表示される' do
        expect(page).to have_content 'お知らせ'
        expect(page).to have_content news.body
      end
      it 'お知らせの「新規作成」のリンクが表示される' do
        expect(page).to have_link "新規作成"
      end
      it 'お知らせの「新規作成」のリンク先が正しい' do
        expect(page).to have_link '新規作成', href: new_admin_news_path
      end
      it 'お知らせの内容のリンク先が正しい' do
        expect(page).to have_link news.body, href: edit_admin_news_path(news)
      end
    end

    context '投稿成功のテスト' do
      before do
        visit new_admin_news_path
        fill_in 'news[body]', with: news.body
      end

      it 'お知らせが正しく保存される' do
        expect { click_button '投稿する' }.to change(News.all, :count).by(1)
      end
      it 'リダイレクト先が、お知らせ一覧(Top画面)になっている' do
        click_button '投稿する'
        expect(current_path).to eq '/'
      end
    end
  end

  describe 'お知らせ編集画面のテスト' do
    before do
      visit edit_admin_news_path(news)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/admin/news/' + news.id.to_s + '/edit'
      end
      it '「お知らせ編集」と表示される' do
        expect(page).to have_content 'お知らせ編集'
      end
      it 'body編集フォームが表示される' do
        expect(page).to have_field 'news[body]', with: news.body
      end
      it '変更内容を保存するボタンが表示される' do
        expect(page).to have_button '変更内容を保存する'
      end
      it '削除するリンクが表示される' do
        expect(page).to have_link '削除する', href: admin_news_path(news)
      end
      it '戻るリンクが表示される' do
        expect(page).to have_link '戻る'
      end
    end

    context '削除するリンクのテスト' do
      before do
        click_link '削除する'
      end

      it '正しく削除される' do
        expect(News.where(id: news.id).count).to eq 0
      end
      it 'リダイレクト先が、Top画面になっている' do
        expect(current_path).to eq '/'
      end
    end

    context '編集成功のテスト' do
      before do
        @news_old_body = news.body
        fill_in 'news[body]', with: Faker::Lorem.characters(number: 10)
        click_button '変更内容を保存する'
      end

      it 'bodyが正しく更新される' do
        expect(news.reload.body).not_to eq @news_old_body
      end
      it 'リダイレクト先が、Top画面になっている' do
        expect(current_path).to eq '/'
      end
    end
  end

end
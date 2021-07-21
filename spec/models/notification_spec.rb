# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification, 'Notificationモデルに関するテスト', type: :model do

  describe 'アソシエーションのテスト' do
    context 'Diaryモデルとの関係' do
      it 'N:1となっている' do
        expect(described_class.reflect_on_association(:diary).macro).to eq :belongs_to
      end
    end
    context 'DiaryCommentモデルとの関係' do
      it 'N:1となっている' do
        expect(described_class.reflect_on_association(:diary_comment).macro).to eq :belongs_to
      end
    end
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(described_class.reflect_on_association(:visitor).macro).to eq :belongs_to
        expect(described_class.reflect_on_association(:visited).macro).to eq :belongs_to
      end
    end
  end

end
require 'rails_helper'

describe ApplicationPolicy do
  subject { described_class }
  @user = FactoryBot.create(:user)

  permissions :edit?, :update?, :index?, :show?, :destroy?, :new?, :create? do
    it 'denies all if not implemented' do
      expect(subject).not_to permit(@user, :anything)
    end
  end
end

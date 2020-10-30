require 'rails_helper'

def create_land(type = :purchase)
  Land.new(
    cemetery_cemid: '04001',
    trustee_id: 1,
    application_type: type,
    status: :received
  )
end

describe Land, type: :model do
  subject { create_land }

  context Land, 'Instance Methods' do
    describe Land, '#formatted_application_type' do
      it 'returns the correct application type' do
        expect(subject.formatted_application_type).to eq 'Land purchase'
      end
    end

    describe Land, '#to_sym' do
      it 'returns the correct symbol' do
        expect(subject.to_sym).to be :land
      end
    end
  end

  context Land, 'Scopes' do
    before :each do
      FactoryBot.create(:cemetery)
      FactoryBot.create(:trustee)
      @me = FactoryBot.create(:user)
      @active_purchase = create_land
      @active_purchase.update(investigator: @me)
      @completed_purchase = create_land
      @completed_purchase.update(investigator: @me, status: :approved)
      @active_sale = create_land(:sale)
      @active_sale.update(investigator: @me)
      @completed_sale = create_land(:sale)
      @completed_sale.update(investigator: @me, status: :approved)
      @other_user = FactoryBot.create(:user)
      @other_user_active_purchase = create_land
      @other_user_active_purchase.update(investigator: @other_user)
      @other_user_active_sale = create_land(:sale)
      @other_user_active_sale.update(investigator: @other_user)
    end

    describe Land, '.active_purchases_for' do
      it 'returns only active purchases for only the selected investigator' do
        expect(Land.active_purchases_for(@me)).to eq [@active_purchase]
      end
    end

    describe Land, '.active_sales_for' do
      it 'returns only active sales for only the selected investigator' do
        expect(Land.active_sales_for(@me)).to eq [@active_sale]
      end
    end
  end
end

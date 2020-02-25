require "rails_helper"

RSpec.describe MembersController, type: :controller do
  include Devise::Test::ControllerHelpers

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in current_user
  end

  let(:current_user) { create(:user) }
  let(:member) { build(:member) }
  let(:member_params) { member.slice(:name, :email, :campaign_id) }

  describe "#create" do
    before do
      request.env["HTTP_ACCEPT"] = 'application/json'
      post :create, params: { member: member_params }
    end

    it "creates a member" do
      expect(Member.last.name).to eq member_params[:name]
      expect(Member.last.email).to eq member_params[:email]
      expect(Member.last.campaign_id).to eq member_params[:campaign_id]
    end

    it "renders a json with member" do
      expect(response.body).to eq Member.last.to_json
    end
  end
end

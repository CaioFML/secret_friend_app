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

  describe "POST #create" do
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

  describe "DELETE #destroy" do
    before do
      request.env["HTTP_ACCEPT"] = 'application/json'
      delete :destroy, params: { id: member.id }
    end

    context "when member is in the campaign owner" do
      let(:member) { create(:member, campaign: create(:campaign, user: current_user)) }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns true in json body" do
        expect(response.body).to eq "true"
      end
    end

    context "when member isn't in the campaign owner" do
      let(:member) { create(:member) }

      it "return http forbidden" do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "PUT #update" do
    before do
      request.env["HTTP_ACCEPT"] = 'application/json'
      put :update, params: { id: member.id, member: member_params }
    end

    context "when member is in the campaign owner" do
      let(:member) { create(:member, campaign: create(:campaign, user: current_user)) }
      let(:member_params) do
        { name: "Caio", email: "caio@gmail.com" }
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "updates member attributes" do
        expect(Member.last.name).to eq member_params[:name]
        expect(Member.last.email).to eq member_params[:email]
      end

      it "returns true in json body" do
        expect(response.body).to eq "true"
      end
    end

    context "when member isn't in the campaign owner" do
      let(:member) { create(:member) }

      it "returns http forbidden" do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "GET #opened" do
    before do
      member.set_pixel
      get :opened, params: { token: member.token }
      member.reload
    end

    let(:member) { create(:member) }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "sets member to opened" do
      expect(member.open).to be true
    end
  end
end

require 'test_helper'

class DiplomaciesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  setup do
    sign_in users(:normal_one)
    @diplomacy = diplomacies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:diplomacies)
  end

  # test "should get new" do
    # get :new
    # assert_response :success
  # end

  # test "should create diplomacy" do
    # assert_difference('Diplomacy.count') do
      # post :create, diplomacy: { from_kingdom_id: @diplomacy.from_kingdom_id, karma: @diplomacy.karma, last_interaction: @diplomacy.last_interaction, to_kingdom_id: @diplomacy.to_kingdom_id }
    # end

    # assert_redirected_to diplomacy_path(assigns(:diplomacy))
  # end

  test "should show diplomacy" do
    get :show, id: @diplomacy
    assert_response :success
  end

  # test "should get edit" do
    # get :edit, id: @diplomacy
    # assert_response :success
  # end

  # test "should update diplomacy" do
    # patch :update, id: @diplomacy, diplomacy: { from_kingdom_id: @diplomacy.from_kingdom_id, karma: @diplomacy.karma, last_interaction: @diplomacy.last_interaction, to_kingdom_id: @diplomacy.to_kingdom_id }
    # assert_redirected_to diplomacy_path(assigns(:diplomacy))
  # end

  # test "should destroy diplomacy" do
    # assert_difference('Diplomacy.count', -1) do
      # delete :destroy, id: @diplomacy
    # end

    # assert_redirected_to diplomacies_path
  # end
end

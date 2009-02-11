require 'test_helper'

class PrecinctSplitsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:precinct_splits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create precinct_split" do
    assert_difference('PrecinctSplit.count') do
      post :create, :precinct_split => { }
    end

    assert_redirected_to precinct_split_path(assigns(:precinct_split))
  end

  test "should show precinct_split" do
    get :show, :id => precinct_splits(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => precinct_splits(:one).id
    assert_response :success
  end

  test "should update precinct_split" do
    put :update, :id => precinct_splits(:one).id, :precinct_split => { }
    assert_redirected_to precinct_split_path(assigns(:precinct_split))
  end

  test "should destroy precinct_split" do
    assert_difference('PrecinctSplit.count', -1) do
      delete :destroy, :id => precinct_splits(:one).id
    end

    assert_redirected_to precinct_splits_path
  end
end

require File.dirname(__FILE__) + '/../test_helper'

class JunkInTheTrunksControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:junk_in_the_trunks)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_junk_in_the_trunk
    assert_difference('JunkInTheTrunk.count') do
      post :create, :junk_in_the_trunk => { }
    end

    assert_redirected_to junk_in_the_trunk_path(assigns(:junk_in_the_trunk))
  end

  def test_should_show_junk_in_the_trunk
    get :show, :id => junk_in_the_trunks(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => junk_in_the_trunks(:one).id
    assert_response :success
  end

  def test_should_update_junk_in_the_trunk
    put :update, :id => junk_in_the_trunks(:one).id, :junk_in_the_trunk => { }
    assert_redirected_to junk_in_the_trunk_path(assigns(:junk_in_the_trunk))
  end

  def test_should_destroy_junk_in_the_trunk
    assert_difference('JunkInTheTrunk.count', -1) do
      delete :destroy, :id => junk_in_the_trunks(:one).id
    end

    assert_redirected_to junk_in_the_trunks_path
  end
end

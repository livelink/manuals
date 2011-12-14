require 'test_helper'

class ManualsControllerTest < ActionController::TestCase
  setup do
    @manual = manuals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manuals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manual" do
    assert_difference('Manual.count') do
      post :create, :manual => @manual.attributes
    end

    assert_redirected_to manual_path(assigns(:manual))
  end

  test "should show manual" do
    get :show, :id => @manual.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @manual.to_param
    assert_response :success
  end

  test "should update manual" do
    put :update, :id => @manual.to_param, :manual => @manual.attributes
    assert_redirected_to manual_path(assigns(:manual))
  end

  test "should destroy manual" do
    assert_difference('Manual.count', -1) do
      delete :destroy, :id => @manual.to_param
    end

    assert_redirected_to manuals_path
  end
end

require 'test_helper'

class PartialsControllerTest < ActionController::TestCase
  setup do
    @partial = partials(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:partials)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create partial" do
    assert_difference('Partial.count') do
      post :create, partial: { doc_number_lp: @partial.doc_number_lp, document_num: @partial.document_num, home_value: @partial.home_value, legal_desc: @partial.legal_desc, mail_city: @partial.mail_city, mail_county: @partial.mail_county, mail_state: @partial.mail_state, mail_str_addr: @partial.mail_str_addr, mail_zip: @partial.mail_zip, owner: @partial.owner, prop_acct_num: @partial.prop_acct_num, prop_city: @partial.prop_city, prop_county: @partial.prop_county, prop_state: @partial.prop_state, prop_str_addr: @partial.prop_str_addr, prop_zip: @partial.prop_zip, record_date: @partial.record_date }
    end

    assert_redirected_to partial_path(assigns(:partial))
  end

  test "should show partial" do
    get :show, id: @partial
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @partial
    assert_response :success
  end

  test "should update partial" do
    patch :update, id: @partial, partial: { doc_number_lp: @partial.doc_number_lp, document_num: @partial.document_num, home_value: @partial.home_value, legal_desc: @partial.legal_desc, mail_city: @partial.mail_city, mail_county: @partial.mail_county, mail_state: @partial.mail_state, mail_str_addr: @partial.mail_str_addr, mail_zip: @partial.mail_zip, owner: @partial.owner, prop_acct_num: @partial.prop_acct_num, prop_city: @partial.prop_city, prop_county: @partial.prop_county, prop_state: @partial.prop_state, prop_str_addr: @partial.prop_str_addr, prop_zip: @partial.prop_zip, record_date: @partial.record_date }
    assert_redirected_to partial_path(assigns(:partial))
  end

  test "should destroy partial" do
    assert_difference('Partial.count', -1) do
      delete :destroy, id: @partial
    end

    assert_redirected_to partials_path
  end
end

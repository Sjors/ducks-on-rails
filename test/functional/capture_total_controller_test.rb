require File.dirname(__FILE__) + '/../test_helper'
require 'capture_total_controller'

# Re-raise errors caught by the controller.
class CaptureTotalController; def rescue_action(e) raise e end; end

class CaptureTotalControllerTest < Test::Unit::TestCase
  fixtures :capture_totals

  def setup
    @controller = CaptureTotalController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = capture_totals(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:capture_totals)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:capture_total)
    assert assigns(:capture_total).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:capture_total)
  end

  def test_create
    num_capture_totals = CaptureTotal.count

    post :create, :capture_total => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_capture_totals + 1, CaptureTotal.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:capture_total)
    assert assigns(:capture_total).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      CaptureTotal.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      CaptureTotal.find(@first_id)
    }
  end
end

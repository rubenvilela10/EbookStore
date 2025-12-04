require "test_helper"

class EbookMetricsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ebook_metric = ebook_metrics(:one)
  end

  test "should get index" do
    get ebook_metrics_url
    assert_response :success
  end

  test "should get new" do
    get new_ebook_metric_url
    assert_response :success
  end

  test "should create ebook_metric" do
    assert_difference("ebookMetric.count") do
      post ebook_metrics_url, params: { ebook_metric: {} }
    end

    assert_redirected_to ebook_metric_url(ebookMetric.last)
  end

  test "should show ebook_metric" do
    get ebook_metric_url(@ebook_metric)
    assert_response :success
  end

  test "should get edit" do
    get edit_ebook_metric_url(@ebook_metric)
    assert_response :success
  end

  test "should update ebook_metric" do
    patch ebook_metric_url(@ebook_metric), params: { ebook_metric: {} }
    assert_redirected_to ebook_metric_url(@ebook_metric)
  end

  test "should destroy ebook_metric" do
    assert_difference("ebookMetric.count", -1) do
      delete ebook_metric_url(@ebook_metric)
    end

    assert_redirected_to ebook_metrics_url
  end
end

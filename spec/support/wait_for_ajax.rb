module WaitForJs
  def wait_for_ajax
    Timeout.timeout(Capybara.default_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def wait_for_animations
    Timeout.timeout(Capybara.default_wait_time) do
      loop until finished_all_animations?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end

  def finished_all_animations?
    page.evaluate_script('$(":animated").length').zero?
  end
end

RSpec.configure do |config|
  config.include WaitForJs, type: :feature
end


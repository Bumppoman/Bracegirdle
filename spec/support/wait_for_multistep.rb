require 'timeout'

module WaitForMultistep
  def wait_for_multistep(&block)
    yield if block_given?
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop do
        sleep 0.1
        break if finished_multistep?
      end
    end
  end

  def finished_multistep?
    page.evaluate_script('window.animating') == false
  end
end

RSpec.configure do |config|
  config.include WaitForMultistep, type: :feature
end
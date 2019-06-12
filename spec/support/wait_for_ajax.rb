# Ajax testing with ruby and capybara
#
# Add this to spec/support
#
# When a link or button starts an ajax request, instead  of use Capybara
# click_link, click_button and click_link_or_button methods use click_ajax_link,
# click_ajax_button and click_ajax_link_or_button methods. You can still use
# capybara methods and right after it, call wait_for_ajax method.
#
# This methods will wait until Capybara.default_max_wait_time for the ajax request
# to finish before continue the normal tests flow.
#
require 'timeout'

module WaitForAjax
  def wait_for_ajax
    max_time = Capybara::Helpers.monotonic_time + Capybara.default_max_wait_time
    while Capybara::Helpers.monotonic_time < max_time
      finished = finished_all_ajax_requests?
      if finished
        break
      else
        sleep 0.1
      end
    end
    raise 'wait_for_ajax timeout' unless finished
  end


  def finished_all_ajax_requests?
    page.evaluate_script(<<~EOS
((typeof window.jQuery === 'undefined')
 || (typeof window.jQuery.active === 'undefined')
 || (window.jQuery.active === 0))
&& ((typeof window.injectedJQueryFromNode === 'undefined')
 || (typeof window.injectedJQueryFromNode.active === 'undefined')
 || (window.injectedJQueryFromNode.active === 0))
&& ((typeof window.httpClients === 'undefined')
 || (window.httpClients.every(function (client) { return (client.activeRequestCount === 0); })))
    EOS
    )
  end
end

RSpec.configure do |config|
  config.include WaitForAjax, type: :feature
end
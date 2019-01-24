# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

(($) ->

  ready = ->

    original_cemeteries = $("#non_compliance_notice_cemetery").html()

    $("#non_compliance_notice_cemetery_county").change ->
      $("#non_compliance_notice_cemetery").html(original_cemeteries)
      county = $(this).find(":selected").text() + " County"
      $("#non_compliance_notice_cemetery optgroup").each ->
        if $(this).attr('label') != county
          $(this).children().remove()
          $(this).remove()

    $("#non_compliance_notice_violation_date, #non_compliance_notice_response_required_date, #non_compliance_notice_response_received_date, #non_compliance_notice_follow_up_inspection_date").datepicker({
      showOn: "button",
      buttonText: "<i class=\"fa fa-calendar\"></i>"
    }).next("button").button({
    }).addClass("btn btn-default").wrap('<span class="input-group-btn">').find('.ui-button-text').css({
      'visibility': 'hidden',
      'display': 'inline'
    });

    $('#non-compliance-notices-data-table').DataTable({
      lengthMenu: [[10, 20, 50, -1], [10, 20, 50, "All"]],
      language: {
        emptyTable: "There are no Notices of Non-Compliance to display"
      }
    })

    $('#non-compliance-download-notice').modal()


  $(document).on('turbolinks:load', ready)
) jQuery
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

(($) ->

  ready = ->

    original_cemeteries = $("#non_compliance_notice_cemetery").html()

    limitCemeteries = ->
      $("#non_compliance_notice_cemetery").prop('disabled', false)
      $("#non_compliance_notice_cemetery").html(original_cemeteries)
      county = $("#non_compliance_notice_cemetery_county").find(":selected").text() + " County"
      $("#non_compliance_notice_cemetery optgroup").each ->
        if $(this).attr('label') != county
          $(this).children().remove()
          $(this).remove()

    if $("#non_compliance_notice_cemetery").val() != "" || $("#non_compliance_notice_cemetery_county").val() != ""
      limitCemeteries()

    $("#non_compliance_notice_cemetery_county").change(limitCemeteries)

    $('#non-compliance-notices-data-table').DataTable({
      responsive: true,
      language: {
        emptyTable: "There are no Notices of Non-Compliance to display."
        searchPlaceholder: 'Search...',
        sSearch: '',
        lengthMenu: '_MENU_ items/page',
      }
    });

    $('#non-compliance-download-notice').modal()

    notice_sections = {
      1: "#notice-issued",
      2: "#response-received",
      3: "#follow-up-complete",
      4: "#notice-resolved"
    }

    display_number = $('div.multi_step_form').data('display-section')
    if display_number > 1
      nextItem($(notice_sections[display_number - 1]))

  $(document).on('turbolinks:load', ready)
) jQuery
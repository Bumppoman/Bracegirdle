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

    $('#edit-response-received-date').click ->
      $('#response-received-edit-text').hide()
      $('#response-received-area').show()
      return false;

    $('#cancel-response-received-date').click ->
      $('#response-received-edit-text').show()
      $('#response-received-area').hide()
      return false;

    $('#edit-follow-up-inspection-date').click ->
      $('#follow-up-inspection-edit-text').hide()
      $('#follow-up-inspection-area').show()
      return false;

    $('#cancel-follow-up-inspection-date').click ->
      $('#follow-up-inspection-edit-text').show()
      $('#follow-up-inspection-area').hide()
      return false;

  $(document).on('turbolinks:load', ready)
) jQuery
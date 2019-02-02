# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

(($) ->

  ready = ->

    original_cemeteries = $("#complaint_cemetery").html()

    limitCemeteries = ->
      $("#complaint_cemetery").prop('disabled', false)
      $("#complaint_cemetery").html(original_cemeteries)
      county = $("#complaint_cemetery_county").find(":selected").text() + " County"
      $("#complaint_cemetery optgroup").each ->
        if $(this).attr('label') != county
          $(this).children().remove()
          $(this).remove()

    if $("#complaint_cemetery").val() != "" || $("#complaint_cemetery_county").val() != ""
      limitCemeteries()

    $("#complaint_cemetery_county").change(limitCemeteries)

    cemetery_select = ->
      if $("#complaint_cemetery_regulated_true").is(":checked")
        $("#complaint-cemetery-select-area").show()
        $("#complaint_cemetery_alternate_name").hide()
      else
        $("#complaint-cemetery-select-area").hide()
        $("#complaint_cemetery_alternate_name").show()

    cemetery_select()

    $("input[name=complaint\\[cemetery_regulated\\]]").change(cemetery_select)

    investigator_select = ->
      if $("#complaint_investigation_required_true").is(":checked")
        $("#complaint_investigator").prop("disabled", false)
        $("#complaint-disposition").hide()
      else
        $("#complaint_investigator").prop("disabled", true)
        $("#complaint-disposition").show()

    investigator_select()

    $("input[name=complaint\\[investigation_required\\]]").change(investigator_select)

    $('#complaints-data-table').DataTable({
      responsive: true,
      language: {
        emptyTable: "There are no complaints to display."
        searchPlaceholder: 'Search...',
        sSearch: '',
        lengthMenu: '_MENU_ items/page',
      }
    });

    $('#edit-investigator').click ->
      $('#current-investigator-name').hide()
      $('#edit-investigator').hide()
      $('#edit-investigator-area').show()
      $('#complaint_investigator').prop("disabled", false)
      return false;

    $('#cancel-edit-investigator').click ->
      $('#edit-investigator-area').hide()
      $('#edit-investigator').show()
      $('#current-investigator-name').show()
      return false;

    complaints_sections = {
      1: "#complaint-received",
      2: "#investigation-begun",
      3: "#investigation-complete",
      4: "#complaint-closed"
    }

    display_number = $('div.multi_step_form').data('display-section')
    if display_number > 1
      nextItem($(complaints_sections[display_number - 1]))

  $(document).on('turbolinks:load', ready)

) jQuery

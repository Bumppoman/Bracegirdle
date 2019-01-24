# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

(($) ->

  ready = ->

    original_cemeteries = $("#complaint_cemetery").html()

    $("#complaint_cemetery_county").change ->
      $("#complaint_cemetery").html(original_cemeteries)
      county = $(this).find(":selected").text() + " County"
      $("#complaint_cemetery optgroup").each ->
        if $(this).attr('label') != county
          $(this).children().remove()
          $(this).remove()

    cemetery_select = ->
      if $("#complaint_cemetery_regulated_true").is(":checked")
        $("#complaint_cemetery").show()
        $("#complaint_cemetery_alternate_name").hide()
      else
        $("#complaint_cemetery").hide()
        $("#complaint_cemetery_alternate_name").show()

    cemetery_select()

    $("input[name=complaint\\[cemetery_regulated\\]]").change(cemetery_select)

    investigator_select = ->
      if $("#complaint_investigation_required_true").is(":checked")
        $("#investigator-div").addClass("required")
        $("#complaint_investigator").prop("disabled", false)
        $("#complaint_investigation_overview").show()
        $("#complaint_disposition").hide()
      else
        $("#investigator-div").removeClass("required")
        $("#complaint_investigator").prop("disabled", true)
        $("#complaint_investigation_overview").hide()
        $("#complaint_disposition").show()

    investigator_select()

    $("input[name=complaint\\[investigation_required\\]]").change(investigator_select)


    $("#complaint_date_of_event, #complaint_date_complained_to_cemetery, #complaint_date_acknowledged, #complaint_investigation_begin_date, #complaint_investigation_completion_date").datepicker({
      showOn: "button",
      buttonText: "<i class=\"fa fa-calendar\"></i>"
    }).next("button").button({
    }).addClass("btn btn-default").wrap('<span class="input-group-btn">').find('.ui-button-text').css({
      'visibility': 'hidden',
      'display': 'inline'
    });

    $('#complaints-data-table').DataTable({
      lengthMenu: [[10, 20, 50, -1], [10, 20, 50, "All"]],
    })

  $(document).on('turbolinks:load', ready)

) jQuery

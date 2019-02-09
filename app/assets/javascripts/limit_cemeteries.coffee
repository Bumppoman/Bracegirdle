# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

(($) ->

  ready = ->

    original_cemeteries = $(".cemeteries-by-county").html()

    limitCemeteries = ->
      $(".cemeteries-by-county").prop('disabled', false)
      $(".cemeteries-by-county").html(original_cemeteries)
      county = $(".county").find(":selected").text() + " County"
      $(".cemeteries-by-county optgroup").each ->
        if $(this).attr('label') != county
          $(this).children().remove()
          $(this).remove()

    if $(".cemeteries-by-county").val() != "" || $(".county").val() != ""
      limitCemeteries()

    $(".county").change(limitCemeteries)


  $(document).on('turbolinks:load', ready)

) jQuery

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

(($) ->

  ready = ->

    $('#restoration_cemetery').change ->
      $('#restoration_trustee').prop('disabled', false)
      selected_cemetery = $("#restoration_cemetery").find(":selected").val()
      $.ajax({
          url: '/cemeteries/' + selected_cemetery + '/trustees/api/list',
          success: (data) ->
            $('#restoration_trustee').html(data)
            $('#restoration_trustee').trigger('change')
      })

      # Update the investigator to select the one assigned to the region
      $.getJSON('/cemeteries/' + selected_cemetery, (data) ->
        $('#restoration_investigator').val(data.investigator.id)
        $('#restoration_investigator').trigger('change')
      )

    $('#restoration-data-table').DataTable({
      responsive: true,
      language: {
        emptyTable: "There are no applications to display.",
        searchPlaceholder: 'Search...',
        sSearch: '',
        lengthMenu: '_MENU_ items/page',
      },
    }).columns(-3).order('asc').draw();

  $(document).on('turbolinks:load', ready)

) jQuery
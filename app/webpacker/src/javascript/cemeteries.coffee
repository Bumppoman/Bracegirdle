# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

(($) ->

  ready = ->

    $('#cemeteries-data-table').DataTable({
      responsive: true,
      language: {
        emptyTable: "There are no cemeteries to display."
        searchPlaceholder: 'Search...',
        sSearch: '',
        lengthMenu: '_MENU_ items/page',
      }
    });

    $('#new-cemetery-county').change ->
      $('#new-cemetery-towns').prop('disabled', false)
      $.ajax({
        url: '/towns/county/' + $('#new-cemetery-county').val() + '/options?selected_value=' + $('.towns-selected-ids').val(),
        success: (data) ->
          $('#new-cemetery-towns').html(data).trigger('change')
    })

    if $('#new-cemetery-county').val() != ''
      $('#new-cemetery-county').trigger('change')

  $(document).on('turbolinks:load', ready)

) jQuery

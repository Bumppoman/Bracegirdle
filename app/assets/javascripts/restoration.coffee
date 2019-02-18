# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

(($) ->

  ready = ->

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
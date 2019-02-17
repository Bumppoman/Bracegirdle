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

  $(document).on('turbolinks:load', ready)

) jQuery

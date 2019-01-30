(($) ->

  ready = ->

    $('.fc-datepicker').datepicker({});

    $('.select2').select2({
      minimumResultsForSearch: Infinity
    });

    $('.select2-show-search').select2({
      minimumResultsForSearch: ''
    });

    $('.dataTables_length select').select2({ minimumResultsForSearch: Infinity });

  $(document).on('turbolinks:load', ready)
) jQuery
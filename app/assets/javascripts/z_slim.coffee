(($) ->
  ready = ->

    $('.fc-datepicker').datepicker({});

    $('.select2').select2({
      minimumResultsForSearch: Infinity,
      selectOnClose: true
    });

    $('.select2-show-search').select2({
      minimumResultsForSearch: '',
      selectOnClose: true
    });

    $('.dataTables_length select').select2({ minimumResultsForSearch: Infinity });


  $(document).on('turbolinks:load', ready)

  $(document).on('focus', '.select2', (e) ->
    if (e.originalEvent)
      $(this).siblings('select').select2('open'));

) jQuery
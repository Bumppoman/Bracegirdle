
(($) ->

  ready = ->
    $('#bootstrap-data-table').DataTable({
      rowGroup: {
        dataSrc: 2
      },
      columnDefs: [
        { visible: false, targets: 2 }
      ],
      lengthMenu: [[10, 20, 50, -1], [10, 20, 50, "All"]],
    })

    $('#bootstrap-data-table-export').DataTable({
      dom: 'lBfrtip',
      lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
      buttons: [
        'copy', 'csv', 'excel', 'pdf', 'print'
      ]
    });

    $('#row-select').DataTable({
      initComplete: ->
        this.api().columns().every(->
          column = this;

          select = $('<select class="form-control"><option value=""></option></select>')
            .appendTo($(column.footer()).empty())
            .on('change', ->
            val = $.fn.dataTable.util.escapeRegex(
              $(this).val()
            )

            column
              .search(val ? '^' + val + '$': '', true, false)
              .draw()
          )

          column.data().unique().sort().each (d, j) ->
            select.append('<option value="' + d + '">' + d + '</option>')
        )
    })

  $(document).on('turbolinks:load', ready)

) jQuery
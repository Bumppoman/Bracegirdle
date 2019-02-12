# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

(($) ->

  ready = ->

    $('#rules-data-table').DataTable({
      responsive: true,
      language: {
        emptyTable: "There are no rules to display.",
        searchPlaceholder: 'Search...',
        sSearch: '',
        lengthMenu: '_MENU_ items/page',
      },
      order: [[2, 'asc']]
    });

    method_select = ->
      if $("#rules_request_by_email_true").is(":checked")
        $("#rules-sender-email").show()
        $("#rules-sender-address").hide()
      else
        $("#rules-sender-email").hide()
        $("#rules-sender-address").show()

    method_select()

    $("input[name=rules\\[request_by_email\\]]").change(method_select)

    $('.custom-file-input').change ->
      i = $(this).next('label').clone();
      file = $(this)[0].files[0].name;
      $(this).next('label').text(file);

    $('.toggle-revision').click (event) ->
      revision = $(this).data('revision')
      $('#revision-' + revision + '-content').toggle()
      event.preventDefault()

  $(document).on('turbolinks:load', ready)
) jQuery
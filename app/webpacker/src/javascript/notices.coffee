# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

(($) ->

  ready = ->

    $('#non-compliance-notices-data-table').DataTable({
      responsive: true,
      language: {
        emptyTable: "There are no Notices of Non-Compliance to display."
        searchPlaceholder: 'Search...',
        sSearch: '',
        lengthMenu: '_MENU_ items/page',
      }
    });

    download = (event = false) ->
      $('#non-compliance-download-notice').modal()
      if event
        event.preventDefault()

    url_params = new URLSearchParams(window.location.search)
    if url_params.has('download_notice')
      download()

    $('#download-notice').click(download)

    notice_sections = {
      1: "#notice-issued",
      2: "#response-received",
      3: "#follow-up-completed",
      4: "#notice-resolved"
    }

    display_number = $('#non-compliance-notice-multi-step-form').data('display-section')
    hide = 1
    while hide < display_number
      nextItem($(notice_sections[hide]), false)
      hide++

  $(document).on('turbolinks:load', ready)
) jQuery
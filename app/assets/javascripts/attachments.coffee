# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

(($) ->

  ready = ->
    $('.delete-attachment').click (e) ->
      e.preventDefault();
      $('#delete-attachment-button').attr('href', '/' + $(this).data('object-name') + '/' + $(this).data('object-id') + '/attachments/' + $(this).data('id'))
      $('#delete-attachment-confirm').modal()

  $(document).on('turbolinks:load', ready)

  $(document).on('direct-upload:start', ->
    $('#attachment-form').hide()
    $('#uploading').addClass('d-flex').show())

) jQuery

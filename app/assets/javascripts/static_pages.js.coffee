# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  
  $('#js-switch-signup').click ->
    $('#login').css('display', 'none')
    $('#signup').css('display', 'block')

  $('#js-switch-login').click ->
    $('#signup').css('display', 'none')
    $('#login').css('display', 'block')

  $('input[name="authenticity_token"]')
    .val($('meta[name="csrf-token"]').attr('content'))
  
  $('#showkey').mousedown ->
    $('input[name="user[password]"]').attr('type', 'text')

  $('#showkey').mouseup ->
    $('input[name="user[password]"]').attr('type', 'password')
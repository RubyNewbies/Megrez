# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

 $(document).on 'click', 'a[data-ajax-node-link]', ->
  history.pushState {}, '', $(this).attr('href')

$(window).bind "popstate", ->
  $.get(document.location.href)

$(document).on 'click', 'a#add_topic', ->
  $(this).closest('form').submit()
  false
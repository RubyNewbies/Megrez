# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  counter = 0

  current_father_id = parseInt($('input#item-id').val())
  current_course_id = parseInt($('input#course-id').val())

  getInputData = (formID, inputID) ->
    $("input##{inputID}[form=#{formID}]").val()

  getFormSerialData = (formID) ->
    utf8: "✓"
    authenticity_token:
      $('meta[name="csrf-token"]').attr('content')
    item: 
      name:  getInputData(formID, "name"),
      weight: parseInt(getInputData(formID, "weight")),
      father_id: current_father_id,
      course_id: current_course_id

  buildRow = (jdata) ->
    $("<tr></tr>")
      .append("<td><a href='/courses/#{current_course_id}/admin/items/#{jdata.id}/edit'>#{jdata.name}</a></td>")
      .append("<td>#{jdata.weight}</td>")
      .append("<td><a href='/courses/#{current_course_id}/admin/items/#{jdata.id}' data-confirm='Are you sure?' data-method='delete' rel='nofollow'>删除</a></td>")

  # submit link clicked
  $('tbody#form-tbody').delegate 'a.data-submit', 'click', ->
    selector = $(this).attr('data-form-id')
    console.log getFormSerialData(selector)
    $.ajax
      type: 'post',
      url: "/courses/#{current_course_id}/admin/items.json",
      data: getFormSerialData(selector),
      success: (data) ->
        $('tr#' + selector).replaceWith(buildRow(data))

  # add a new row
  $("#new-item").click ->
    counter += 1
    $("tbody#form-tbody")
      .append("<tr id='form-#{counter}'></tr>")
    $("tr#form-#{counter}")
      .append("<td><input form='form-#{counter}' id='name'  name='item[name]'  type='text' /></td>")
      .append("<td><input form='form-#{counter}' id='weight' name='item[weight]' type='number' /></td>")
      .append("<td><a class='data-submit' data-form-id='form-#{counter}'>保存</a></td>")

$(document).ready(ready)
$(document).on('page:load', ready)
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  counter = 0

  getInputData = (formID, inputID) ->
    $("input##{inputID}[form=#{formID}]").val()

  getFormSerialData = (formID) ->
    utf8: "✓"
    authenticity_token:
      $('meta[name="csrf-token"]').attr('content')
    node: 
      name:  getInputData(formID, "name"),
      weight: parseInt(getInputData(formID, "weight")),
      father_id: $('input#node_id').val(),
      course_id: $('input#node_course_id').val()

  buildRow = (jdata) ->
    $("<tr></tr>")
      .append("<td>#{jdata.id}</td>")
      .append("<td>#{jdata.name}</td>")
      .append("<td>#{jdata.weight}</td>")
      .append("<td><a class='fa fa-eye' href='/students/#{jdata.id}'></a> <a class='fa fa-pencil-square-o' href='/students/#{jdata.id}/edit'></a> <a class='fa fa-trash' href='/students/#{jdata.id}' data-confirm='Are you sure?' data-method='delete' rel='nofollow'></a></td>")

  # submit link clicked
  $('table').delegate 'a[data-submit]', 'click', ->
    selector = $(this).attr('data-form-id')
    console.log getFormSerialData(selector)
    $.ajax
      type: 'post',
      url: '/courses/1/nodes.json',
      data: getFormSerialData(selector),
      success: (data) ->
        console.log(data)
        $('tr#' + selector).replaceWith(buildRow(data))

  # add a new row
  $("#new-item").click ->
    counter += 1
    $("#for-form")
      .append("<form action='/nodes.json' method='post' id=\"form-#{counter}\" ></form>")
    $("tbody#form-tbody")
      .append("<tr id=\"form-#{counter}\"></tr>")
    $("tr#form-#{counter}")
      .append("<td>#{counter}</td>")
      .append("<td><input form=\"form-#{counter}\" id='name'  name='node[name]'  type='text' /></td>")
      .append("<td><input form=\"form-#{counter}\" id='weight' type='number' name='node[weight]' /></td>")
      .append("<td><a class='fa fa-upload' data-submit data-form-id=\"form-#{counter}\"></a></td>")
      .appendTo($("tbody"))

$(document).ready(ready)
$(document).on('page:load', ready)
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->

  # $('button#join_course').click ->
  #   $(this).attr('disabled', true)
  #   $(this).html("<i class='fa fa-fw fa-spin fa-spinner'></i> 加入中...")
  #   $.post

  # to set summernote object
  # You should change '#post_content' to your textarea input id
  summer_note = $('#course_description')

  # to call summernote editor
  summer_note.summernote
    # to set options
    height: 250
    #lang: 'ko-KR'
    toolbar: [
                ['insert', ['picture', 'link']], #// no insert buttons
                ["table", ["table"]],
                ["style", ["style"]],
                ["fontsize", ["fontsize"]],
                ["color", ["color"]],
                ["style", ["bold", "italic", "underline", "clear"]],
                ["para", ["ul", "ol", "paragraph"]],
                ["height", ["height"]],
                ["help", ["help"]]
             ]

  # to set code for summernote
  summer_note.code summer_note.val()

  # to get code for summernote
  summer_note.closest('form').submit ->
    # alert $('#post_content').code()
    summer_note.val summer_note.code()
    true

  $('button#new_node').click ->
    #$("<i class='fa fa-fw fa-spinner></i> '").prependTo($(this))
    history.pushState
      path: this.path, '', $(this).attr('data-href').replace('.js', '')
    $.get $(this).attr('data-href'), (data) ->
      console.log data
      eval(data)

  $(document).on 'click', 'a#add_node', ->
    #form = $(this).closest('form')
    $(this).closest('form').submit()
    #alert form.attr('action')
    #$.post form.attr('action'),
    #  form.serialize(),
    #  (data) -> eval(data)
    false
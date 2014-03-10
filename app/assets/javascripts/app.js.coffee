$ ->
  $('#new_answer').on 'ajax:success', (_, html) ->
    $(this).replaceWith(html)

    $('#correct_answer_button').click ->
      $('#answer_correct').val('true')


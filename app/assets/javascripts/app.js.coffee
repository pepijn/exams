$ ->
  if new_answer = $('table')
    radio = new_answer.find('input[type=radio]')
    radio.first().focus()

    radio.change ->
      $(this).parents('table').find('tr').removeClass 'active'
      $(this).parents('tr').addClass 'active'


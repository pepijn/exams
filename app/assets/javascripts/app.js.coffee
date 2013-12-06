$ ->
  if new_answer = $('form#new_answer')
    radio = new_answer.find('input[type=radio]')
    radio.last().focus()

    radio.change ->
      $(this).parents('table').find('tr').removeClass 'active'
      $(this).parents('tr').addClass 'active'


$ ->
  if radio = $('input[type="radio"]')
    radio.blur ->
      $(this).parents('table').find('tr').removeClass 'active'
      $(this).parents('tr').addClass 'active'
      $('button').prop 'disabled', false


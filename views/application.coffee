$ ->
  $('input[type="radio"]').change ->
    $(this).parents('table').find('tr').removeClass 'active'
    $(this).parents('tr').addClass 'active'
    $('button').prop 'disabled', false


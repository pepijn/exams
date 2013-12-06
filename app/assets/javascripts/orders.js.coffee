$ ->
  return if $('#order').length == 0

  $('a.list-group-item').click ->
    $(this).find('input[type=radio]').prop('checked', true)

    $('input[type=radio]').parents('.list-group-item').removeClass('active')

    checked = $('input[type=radio]:checked')
    checked.parents('.list-group-item').addClass('active')

    $('button').prop('disabled', false) if checked.length == 2




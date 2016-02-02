ready = ->
  $('#sync-user-dates').on 'click', (event) -> synchronizeDatesIndexPage(event)
  $('.calendar').fullCalendar(get_events_for_view())
  return

$(document).ready(ready)

synchronizeDatesIndexPage = (event) ->
  url = "/user_dates/synchronize_dates_on_index_page.json"
  $.ajax
    url: url
    method: 'GET'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log('error_synchronize_dates')
      alert(I18n.t('global.ajax_failed'))
    success: (data, textStatus, jqXHR) ->
      location.reload()
  event.preventDefault()

get_events_for_view = () ->
  header:
    left: 'prev,next today',
    center: 'title',
    right: 'month,agendaWeek,agendaDay'

  events:
      url: '/user_dates/events_for_calendar_view.json',
      type: 'GET',
      color: '#5F8C1C',
      textColor: 'white'
      error: (jqXHR, textStatus, errorThrown) ->
        console.log('error_synchronize_dates')
        alert(I18n.t('global.ajax_failed'))
      success: (data, textStatus, jqXHR) ->
        console.log('success_synchronize_dates')

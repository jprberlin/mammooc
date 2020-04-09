
ready = ->
  $('#load-account-settings-button').on 'click', (event) -> loadAccountSettings(event)
  $('#load-mooc-provider-settings-button').on 'click', (event) -> loadMoocProviderSettings(event)
  $('#load-privacy-settings-button').on 'click', (event) -> loadPrivacySettings(event)
  $('#load-newsletter-settings-button').on 'click', (event) -> loadNewsletterSettings(event)
  
  $('#add_new_email_field').on 'click', (event) -> addNewEmailField(event)
  $('.remove_added_email_field').on 'click', (event) -> removeAddedEmailField(event)
  $('.remove_email').on 'click', (event) -> markEmailAsDeleted(event)

  $('button.setting-add-button').on 'click', (event) -> addSetting(event)
  $('button.setting-remove-button').on 'click', (event) -> removeSetting(event)
  return

$(document).ready(ready)

addNewEmailField = (event) ->
  event.preventDefault()
  table = document.getElementById('table_for_user_emails')
  index = table.rows.length - 1
  new_row = table.insertRow(index)
  cell_address = new_row.insertCell(0)
  cell_primary = new_row.insertCell(1)
  cell_remove = new_row.insertCell(2)
  html_for_address_field = "<input class='form-control' autofocus='autofocus' type='email' name='user[user_email][address_#{index}]' id='user_user_email_address_#{index}'>"
  cell_address.innerHTML = html_for_address_field
  html_for_primary_field = "<input type='radio' name='user[user_email][is_primary]' value='new_email_index_#{index}' id='user_user_email_is_primary_#{index}'>"
  cell_primary.innerHTML = html_for_primary_field
  html_for_remove_field = "<div class='text-right'><button class='btn btn-xs btn-default remove_added_email_field' id='remove_button_#{index}'><span class='glyphicon glyphicon-remove'></span></button></div>"
  cell_remove.innerHTML = html_for_remove_field
  $("#remove_button_#{index}").closest('.remove_added_email_field').on 'click', (event) -> removeAddedEmailField(event)
  $('#user_index').val(index)

removeAddedEmailField = (event) ->
  event.preventDefault()
  button = $(event.target)
  row_id = button.closest("tr")[0].rowIndex
  table = document.getElementById('table_for_user_emails')
  if $("#user_user_email_is_primary_#{row_id}")[0].checked
    alert(I18n.t('users.settings.change_emails.alert_can_not_delete_primary'))
  else
    table.deleteRow(row_id)

markEmailAsDeleted = (event) ->
  event.preventDefault()
  button = $(event.target)
  email_id = button.data('email_id')
  if $("#user_user_email_is_primary_#{email_id}")[0].checked
    alert(I18n.t('users.settings.change_emails.alert_can_not_delete_primary'))
  else
    url = "/user_emails/#{email_id}/mark_as_deleted.json"

    $.ajax
      url: url
      method: 'GET'
      error: (jqXHR, textStatus, errorThrown) ->
        console.log('error_mark_as_deleted')
        alert(I18n.t('global.ajax_failed'))
      success: (data, textStatus, jqXHR) ->
        console.log('deleted')
        button.closest("tr").hide()


loadAccountSettings = (event) ->
  button = $(event.target)
  user_id = button.data('user_id')
  url = "/users/#{user_id}/account_settings.json"
  $.ajax
    url: url
    method: 'GET'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log('error_synchronize')
      alert(I18n.t('global.ajax_failed'))
    success: (data, textStatus, jqXHR) ->
      $("div.settings-container").html(data.partial)
      bindMoocProviderConnectionClickEvents()
      window.history.pushState({id: 'set_account_subsite'}, '', 'settings?subsite=account');
  event.preventDefault()

loadMoocProviderSettings = (event) ->
  button = $(event.target)
  user_id = button.data('user_id')
  url = "/users/#{user_id}/mooc_provider_settings.json"
  $.ajax
    url: url
    method: 'GET'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log('error_synchronize')
      alert(I18n.t('global.ajax_failed'))
    success: (data, textStatus, jqXHR) ->
      $("div.settings-container").html(data.partial)
      bindMoocProviderConnectionClickEvents()
      window.history.pushState({id: 'set_mooc_provider_subsite'}, '', 'settings?subsite=mooc_provider');
  event.preventDefault()

loadPrivacySettings = (event) ->
  button = $(event.target)
  user_id = button.data('user_id')
  url = "/users/#{user_id}/privacy_settings.json"
  $.ajax
    url: url
    method: 'GET'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log('error_synchronize')
      alert(I18n.t('global.ajax_failed'))
    success: (data, textStatus, jqXHR) ->
      $("div.settings-container").html(data.partial)
      bindMoocProviderConnectionClickEvents()
      window.history.pushState({id: 'set_privacy_subsite'}, '', 'settings?subsite=privacy');
  event.preventDefault()

loadNewsletterSettings = (event) ->
  button = $(event.target)
  user_id = button.data('user_id')
  url = "/users/#{user_id}/newsletter_settings.json"
  $.ajax
    url: url
    method: 'GET'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log('error_synchronize')
      console.log(textStatus)
      alert(I18n.t('global.ajax_failed'))
    success: (data, textStatus, jqXHR) ->
      $("div.settings-container").html(data.partial)
      bindMoocProviderConnectionClickEvents()
      window.history.pushState({id: 'set_newsletter_subsite'}, '', 'settings?subsite=newsletter');
  event.preventDefault()


synchronizeNaiveUserMoocProviderConnection = (event) ->
  button = $(event.target)
  user_id = button.data('user_id')
  mooc_provider = button.data('mooc_provider')
  email = $("#input-email-#{mooc_provider}").val()
  password = $("#input-password-#{mooc_provider}").val()
  url = "/users/#{user_id}/set_mooc_provider_connection.json"
  $.ajax
    url: url
    method: 'GET'
    data:{email:email, password: password, mooc_provider:mooc_provider}
    error: (jqXHR, textStatus, errorThrown) ->
      console.log('error_synchronize')
      alert(I18n.t('global.ajax_failed'))
    success: (data, textStatus, jqXHR) ->
      if data.status == true
        $("div.settings-container").html(data.partial)
      else
        $("#div-error-#{mooc_provider}").text("Error!")
  event.preventDefault()

revokeNaiveUserMoocProviderConnection = (event) ->
  button = $(event.target)
  user_id = button.data('user_id')
  mooc_provider = button.data('mooc_provider')
  url = "/users/#{user_id}/revoke_mooc_provider_connection.json"
  $.ajax
    url: url
    method: 'GET'
    data:{mooc_provider:mooc_provider}
    error: (jqXHR, textStatus, errorThrown) ->
      console.log('error_synchronize')
      alert(I18n.t('global.ajax_failed'))
    success: (data, textStatus, jqXHR) ->
      if data.status == true
        $("div.settings-container").html(data.partial)
      else
        $("#div-error-#{mooc_provider}").text("Error!")
  event.preventDefault()

addSetting = (event) ->
  button = if (event.target.nodeName == 'SPAN') then $(event.target.parentElement) else $(event.target)
  list_id = button.data('list-id')
  list = $("##{list_id}")
  user_id = button.data('user-id')

  ok_button = $('<button></button>')
                .addClass('btn btn-default new-item-ok')
                .append($('<span></span>').addClass('glyphicon glyphicon-ok'))
  ok_button.on 'click', (event) ->
    event.preventDefault()
    name = $("#new-#{list.data('key')}-name").val()
    id = $("#new-#{list.data('key')}-id").val()
    if name != '' && id != ''
      ids = getExistingIDs(list.data('setting'), list.data('key'))
      ids.push id
      $.ajax
        type: 'POST'
        url: "/users/#{user_id}/set_setting"
        data:
          setting: list.data('setting')
          key: list.data('key')
          value: ids
        dataType: 'json'
        success: (data, textStatus, jqXHR) ->
          new_item = $('<li></li>').addClass('list-group-item').data('id', id)
                      .append(name)
                      .append($('<button></button>').addClass('btn btn-xs btn-default pull-right')
                      .data('user-id', user_id)
                      .on('click', removeSetting)
                        .append($('<span></span>').addClass('glyphicon glyphicon-remove')))
          form_item.remove()
          list.prepend(new_item)
        error: (jqXHR, textStatus, errorThrown) ->
          alert(I18n.t('global.ajax_failed'))

    else
      subject = list.data('key').slice(0, -1)
      alert(I18n.t('flash.error.settings.input_empty', subject: I18n.t("flash.error.settings.#{subject}")))

  cancel_button = $('<button></button>')
                    .addClass('btn btn-default new-item-cancel')
                    .append($('<span></span>').addClass('glyphicon glyphicon-remove'))
  cancel_button.on 'click', (event) ->
    event.preventDefault()
    form_item.remove()

  id_input = $('<input></input>').attr('type', 'hidden').attr('id', "new-#{list.data('key')}-id")
  name_input = $('<input></input>').attr('type', 'text').addClass('form-control').attr('id', "new-#{list.data('key')}-name")
  input_source_url = switch list.data('key')
    when 'groups' then '/groups.json'
    when 'users' then "/users/#{user_id}/connected_users_autocomplete.json"

  name_input.autocomplete
    minLength: 0
    delay: 100
    autoFocus: true
    source: (request, response) ->
      $.ajax
        url: input_source_url
        dataType: 'json'
        data:
          q: request.term
        error: (jqXHR, textStatus, errorThrown) ->
          alert(I18n.t('global.ajax_failed'))
        success: (data, textStatus, jqXHR) ->
          results = []
          existing_ids = getExistingIDs(list.data('setting'), list.data('key'))
          for item in data
            label = switch list.data('key')
              when 'groups' then item.name
              when 'users' then "#{item.full_name}"
            results.push({label: label, value: item.id}) if existing_ids.indexOf(item.id) < 0
          response(results)
    select: (event, ui) ->
      id_input.val(ui.item.value)
      name_input.val(ui.item.label)
      return false
    search: (event, ui) ->
      id_input.val('')

  form_item = $('<li></li>').addClass('list-group-item').append(
    $('<form></form>').addClass('form-inline')
      .append($('<div></div>').addClass('form-group')
        .append(name_input)
        .append(id_input))
      .append(ok_button)
      .append(cancel_button))
  list.prepend(form_item)
  name_input.autocomplete('search')
  name_input.focus()

removeSetting = (event) ->
  button = if (event.target.nodeName == 'SPAN') then $(event.target.parentElement) else $(event.target)
  list = button.closest('ul')
  user_id = button.data('user-id')
  ids = getExistingIDs(list.data('setting'), list.data('key'))
  remove_id = button.parent().data('id')
  remove_index = ids.indexOf(remove_id)
  ids.splice(remove_index, 1) if remove_index >= 0
  $.ajax
    type: 'POST'
    url: "/users/#{user_id}/set_setting"
    data:
      setting: list.data('setting')
      key: list.data('key')
      value: ids
    dataType: 'json'
    success: (data, textStatus, jqXHR) ->
      button.parent().remove()
    error: (jqXHR, textStatus, errorThrown) ->
      alert(I18n.t('global.ajax_failed'))

getExistingIDs = (setting, key) ->
  existing_ids = []
  ul_id = "#{setting.replace(/_/g, '-')}-#{key}-list"
  lis = $("##{ul_id}").children()
  $.each lis, (_, li) ->
    existing_ids.push $(li).data('id') if $(li).data('id')

  return existing_ids

@bindMoocProviderConnectionClickEvents = () ->
  $('button[id="sync-naive-user-mooc_provider-connection-button"]').on 'click', (event) ->
    synchronizeNaiveUserMoocProviderConnection(event)
  $('button[id="revoke-naive-user-mooc_provider-connection-button"]').on 'click', (event) ->
    revokeNaiveUserMoocProviderConnection(event)

  $('#add_new_email_field').on 'click', (event) -> addNewEmailField(event)
  $('.remove_added_email_field').on 'click', (event) -> removeAddedEmailField(event)
  $('.remove_email').on 'click', (event) -> markEmailAsDeleted(event)

  $('button.setting-add-button').on 'click', (event) -> addSetting(event)
  $('button.setting-remove-button').on 'click', (event) -> removeSetting(event)

$.fn.userAutocomplete = function () {
  'use strict'

  function formatUserList(values) {
    return values.map(function (obj) {
      return {
        id: obj.id,
        text: obj.attributes.email
      }
    })
  }

  this.select2({
    multiple: true,
    minimumInputLength: 1,
    ajax: {
      url: Spree.routes.users_api,
      dataType: 'json',
      headers: {
        'Authorization': 'Bearer ' + OAUTH_TOKEN,
      },
      data: function (params) {
        return {
          filter: {
            email_i_cont: params.term
          }
        }
      },
      processResults: function(data) {
        return {
          results: formatUserList(data.data)
        }
      }
    },
    templateSelection: function (data) {
      return data.text
    }
  })
}

$(document).ready(function () {
  $('.user_picker').userAutocomplete()
})

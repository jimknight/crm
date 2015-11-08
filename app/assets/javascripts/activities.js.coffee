# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.getClientJson = (client_id) ->
  $.getJSON "/clients/#{client_id}.json", (data) ->
    $("input#activity_city").val(data["city"])
    $("select#activity_state").val(data["state"])
    $("select#activity_contact_id").empty().append('<option value=""></option>')
    $("select#activity_industry").val(data["industry"])
    if data["contacts"].length == 0
      $('label[for="new_contact"]').text("Enter a new contact for this client")
      $('label[for="activity_contact_id"]').hide()
      $("select#activity_contact_id").hide()
    else
      $.each data["contacts"], (idx, obj) ->
        $option = $("<option></option>").attr("value", obj["id"]).text(obj["name"])
        $('label[for="new_contact"]').text("or enter a new contact")
        $('label[for="activity_contact_id"]').show()
        $("select#activity_contact_id").show()
        $("select#activity_contact_id").append $option
        return
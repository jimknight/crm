# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.getClientJson = (client_id) ->
  $.getJSON "/clients/#{client_id}.json", (data) ->
    $("input#activity_city").val(data["city"])
    $("select#activity_state").val(data["state"])
    $("select#activity_contact_id").empty().append('<option value=""></option>')
    $("select#activity_industry").val(data["industry"])
    $.each data["contacts"], (idx, obj) ->
      $option = $("<option></option>").attr("value", obj["id"]).text(obj["name"])
      $("select#activity_contact_id").append $option
      return
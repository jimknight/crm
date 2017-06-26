$(document).on('turbolinks:load', function() {
  console.log("page loaded");
  $('input#client_name').bind('railsAutocomplete.select', function(event, data){
    getClientJson(data.item.id);
    $("input#activity_client_id").val(data.item.id);
  });
});

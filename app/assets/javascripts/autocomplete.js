$( document ).ready(function() {
  $('input#client_name').bind('railsAutocomplete.select', function(event, data){
    getClientJson(data.item.id);
    $("input#activity_client_id").val(data.item.id);
  });
});
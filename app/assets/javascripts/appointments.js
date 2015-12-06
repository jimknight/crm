var default_picker_options = {
  format: false,
  dayViewHeaderFormat: 'MMMM YYYY',
  extraFormats: false,
  stepping: 1,
  minDate: false,
  maxDate: false,
  useCurrent: true,
  collapse: true,
  locale: moment.locale(),
  defaultDate: false,
  disabledDates: false,
  enabledDates: false,
  icons: {
      time: 'glyphicon glyphicon-time',
      date: 'glyphicon glyphicon-calendar',
      up: 'glyphicon glyphicon-chevron-up',
      down: 'glyphicon glyphicon-chevron-down',
      previous: 'glyphicon glyphicon-chevron-left',
      next: 'glyphicon glyphicon-chevron-right',
      today: 'glyphicon glyphicon-screenshot',
      clear: 'glyphicon glyphicon-trash'
  },
  useStrict: false,
  sideBySide: false,
  daysOfWeekDisabled: [],
  calendarWeeks: false,
  viewMode: 'days',
  toolbarPlacement: 'default',
  showTodayButton: false,
  showClear: false,
  widgetPositioning: {
      horizontal: 'left',
      vertical: 'auto'
  },
  disallowReadOnly: true,
  keepOpen: false,
  inline: false
}

$(document).on('ready page:change', function() {
  $('.datetimepicker').datetimepicker(default_picker_options);
});

window.getClientJsonAppt = function(client_id) {
  return $.getJSON("/clients/" + client_id + ".json", function(data) {
    $("select#appointment_contact_id").empty().append('<option value=""></option>');
    if (data["contacts"].length === 0) {
      $('label[for="new_contact"]').text("Enter a new contact for this client");
      $('label[for="appointment_contact_id"]').hide();
      return $("select#appointment_contact_id").hide();
    } else {
      return $.each(data["contacts"], function(idx, obj) {
        var $option;
        $option = $("<option></option>").attr("value", obj["id"]).text(obj["name"]);
        $('label[for="new_contact"]').text("or enter a new contact");
        $('label[for="appointment_contact_id"]').show();
        $("select#appointment_contact_id").show();
        $("select#appointment_contact_id").append($option);
      });
    }
  });
};

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
      horizontal: 'auto',
      vertical: 'auto'
  },
  disallowReadOnly: true,
  keepOpen: false,
  inline: false
}

$(document).on('ready page:change', function() {
  $('.datetimepicker').datetimepicker(default_picker_options);
});
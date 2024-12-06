// app/assets/javascripts/timezone_detection.js
document.addEventListener("DOMContentLoaded", function() {
  // Detect the user's time zone using JavaScript's Intl API
  var timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;

  // Set the value of the hidden field to the detected time zone
  var timeZoneField = document.getElementById('event_time_zone');
  if (timeZoneField) {
    timeZoneField.value = timeZone;
  }
});

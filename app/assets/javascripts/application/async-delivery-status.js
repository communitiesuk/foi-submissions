/* global $ */

var checkDeliveryStatus = function () {
  var $box = $(this)
  var source = $box.data('source')
  var $ref = $('.js-submission-reference', $box)

  // The "generic" and "delivered" states will already have been hidden by
  // the CSS, and the "loading" state shown
  var runs = 0
  var runTimer = function () {
    runs++

    // Abort after 5 attempts (which takes approx 5 seconds) and just show the
    // generic message
    if (runs > 5) {
      $box.find('.async-delivery-status--loading').hide()
      $box.find('.async-delivery-status--generic').show()
      return
    }

    setTimeout(function () {
      $.get(source, function (data) {
        var ref = data.reference

        if (ref) {
          // Once went have a reference show the delivered message
          $ref.text(ref)

          $box.find('.async-delivery-status--loading').hide()
          $box.find('.async-delivery-status--delivered').show()
        } else {
          // No reference this this so requeue timer
          runTimer()
        }
      })
      // Go easy on the server and increase the length of time between each
      // attempt
    }, 500 + (250 * runs))
  }

  runTimer()
}

$(document).ready(function () {
  $('.js-async-delivery-status').each(checkDeliveryStatus)
})

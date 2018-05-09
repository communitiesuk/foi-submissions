/* global $ */

$('.js-async-delivery-status').each(function () {
  var $box = $(this)

  // The "generic" and "delivered" states will already have been hidden by
  // the CSS, and the "loading" state shown. So we just need wait a random
  // amount of time, then hide "loading" and show "delivered";
  var randomDelay = Math.floor(Math.random() * 5000)
  setTimeout(function () {
    $box.find('.async-delivery-status--loading').hide()
    $box.find('.async-delivery-status--delivered').show()
  }, randomDelay)
})

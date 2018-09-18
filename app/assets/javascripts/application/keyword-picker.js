/* global $, Taggle */

var removeEmptyItems = function (array) {
  var cleaned = []
  for (var i=0; i<array.length; i++) {
    var trimmedItem = $.trim(array[0])
    if (trimmedItem === 0 || trimmedItem){
      cleaned.push(array[i])
    }
  }
  return cleaned
}

var CSVToArray = function (csvString) {
  var array = removeEmptyItems(csvString.split(','))
  for (var i=0; i<array.length; i++) {
    // Upwrap outer quotes if they exist.
    array[i] = array[i].replace(/(^"|"$)/g, '')
    // Unescape any remaining quotes.
    array[i] = array[i].replace(/""/g, '"')
  }
  return array
}

var arrayToCSV = function (array) {
  var escaped = [];
  for (var i=0; i<array.length; i++) {
    // If value contains quotes, whitespace, or commas…
    if (array[i].match(/[\r\n,"]/)) {
      // Escape quotes, if they exist.
      array[i] = array[i].replace(/"/g, '""')
      // Then wrap everything in quotes.
      array[i] = '"' + array[i] + '"'
    }
    escaped.push(array[i])
  }
  return escaped.join(',')
}

var setUpKeywordPicker = function () {
  var $originalInput = $(this)
  var $label = $('label[for="' + $originalInput.attr('id') + '"]')
  var originalInputClasses = removeEmptyItems( $originalInput.attr('class').split(/\s+/) )
  var originalInputKeywords = CSVToArray( $originalInput.val() )
  var originalInputPlaceholder = $originalInput.attr('placeholder') || null
  var taggleInstance

  var $fakeInput = $('<div>')
  $fakeInput.addClass('keyword-picker-fake-input')
  $.each(originalInputClasses, function (i, cls) {
    if (cls !== 'js-keyword-picker') {
      $fakeInput.addClass(cls)
    }
  })

  $fakeInput.insertAfter($originalInput)
  $originalInput.hide()

  var saveTagsToInput = function () {
    var tagsAsCSV = arrayToCSV(taggleInstance.getTagValues())
    return $originalInput.val(tagsAsCSV)
  }

  var taggleOptions = {
    placeholder: originalInputPlaceholder,
    tags: originalInputKeywords,
    tabIndex: 0,
    saveOnBlur: true,
    onTagAdd: function (e, tag){
      saveTagsToInput()
    },
    onTagRemove: function (e, tag){
      saveTagsToInput()
    }
  }

  taggleInstance = new Taggle($fakeInput[0], taggleOptions)

  // The input is now more interactive, so update
  // the hint text to explain how to save keywords.
  $label.find('.form-hint').html('Type a comma, Return, or Enter to finish a keyword')
}

// Filter out older browsers, like IE8.
if (window.getComputedStyle && Array.prototype.map && Array.prototype.forEach) {
  document.addEventListener('turbolinks:load', function () {
    $('.js-keyword-picker').each(setUpKeywordPicker)
  })
}

/* global $ */

var updateCuratedLinkPreview = function (inputs, previews) {
    previews.$url.attr('href', inputs.$url.val() || '#')
    previews.$title.text(inputs.$title.val() || '[no title]')
    previews.$summary.text(inputs.$summary.val())
}

var setUpCuratedLinkPreview = function () {
    var $preview = $(this)
    var inputs = {
        $url: $('#curated_link_url'),
        $title: $('#curated_link_title'),
        $summary: $('#curated_link_summary')
    }
    var previews = {
        $url: $preview.find('.js-suggestion-link'),
        $title: $preview.find('.js-suggestion-title'),
        $summary: $preview.find('.js-suggestion-summary')
    }

    inputs.$url.on('keyup', function(){
        updateCuratedLinkPreview(inputs, previews)
    });

    inputs.$title.on('keyup', function(){
        updateCuratedLinkPreview(inputs, previews)
    });

    inputs.$summary.on('keyup', function(){
        updateCuratedLinkPreview(inputs, previews)
    });

    updateCuratedLinkPreview(inputs, previews)
}

$('.js-curated-link-preview').each(setUpCuratedLinkPreview)

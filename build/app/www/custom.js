/* When recalculating starts, show loading screen */
$(document).on('shiny:recalculating', function(event) {
$('div#wc-divLoading').addClass('show');
});

/* When new value or error comes in, hide loading screen */
$(document).on('shiny:value shiny:error', function(event) {
$('div#wc-divLoading').removeClass('show');
});

$(document).on('shiny:recalculating', function(event) {
$('div#al-divLoading').addClass('show');
});

/* When new value or error comes in, hide loading screen */
$(document).on('shiny:value shiny:error', function(event) {
$('div#al-divLoading').removeClass('show');
});

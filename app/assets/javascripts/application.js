// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jqModal
//= require selectToUISlider.jQuery
//= require nested_form/jquery
//= require jquery.remotipart
//= require ios-checkboxes
//= require_self
// #= require_tree .

$(document).ready(function() {
    setTimeout(function() {
        // Appear/Disappear
        $('.expandable > li > a.expanded').parent().find('> ul').show();
        $('.expandable a[id="arrow"]').click(function() {
            $(this).toggleClass('expanded').toggleClass('collapsed').parent().find('> ul').toggle();
        });
    }, 250);
});

$(function() {
    $('[id^=show_][id$=_wizard]').click(function() {
        $(this).addClass('ac_loading');
    });

    $('#back_button').live('click', function() {
        $(this).addClass('ac_loading');
    });

    $('input[type=submit]', '#wizard').live('click', function() {
        $(this).addClass('ac_loading');
    });

    $('form', '#wizard').live('submit', function() {
        $('.basic_field').attr('disabled', 'disabled');
        $('.remove_button').css('visibility', 'hidden');
    });

    $(document).keydown(function(e) {
        if (e.which == 27) {  // escape, close box
            $('#close_modal').click();
        }
    });

//    $('#metadata_checkbox_container').click(function() {
//        if ($('#metadata_checkbox').checked) {
//            $("#save_button").text('Blah');
//            alert();
//        }
//    });




});
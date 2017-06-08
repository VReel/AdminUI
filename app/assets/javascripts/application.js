// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-datepicker
//= require_tree .
//

$(function() {
  $('.toggle-api-data').click(function() {
    if ($('.api-data').is(':visible')) {
      $('.api-data').addClass('hidden');
    }
    else {
      $('.api-data').removeClass('hidden');
    }
  });

  function expandFilters() {
    if ($('.filters').hasClass('hidden')) {
      $('.filters-toggle').trigger('click');
    }
  }

  $('.filter-toggle').click(function() {
    var $icon = $(this).find('.fa');
    $(this).parents('.filter-wrapper').find('.filter').toggleClass('hidden')
    if ($icon.hasClass('fa-caret-up')) {
      $icon.removeClass('fa-caret-up').addClass('fa-caret-down');
    }
    else {
      $icon.removeClass('fa-caret-down').addClass('fa-caret-up');
    }
  });

  $('.filters-toggle').click(function() {
    var $icon = $(this).find('.fa').first();
    $('.filters').toggleClass('hidden')
    if ($icon.hasClass('fa-caret-up')) {
      $icon.removeClass('fa-caret-up').addClass('fa-caret-down');
    }
    else {
      $icon.removeClass('fa-caret-down').addClass('fa-caret-up');
    }
  });

  $('.filter-wrapper').each(function() {
    if ($(this).find('input[value]:not([value=""])').length) {
      $(this).find('.filter-toggle').trigger('click');
      expandFilters();
    }

    if ($(this).find('option[selected][value]:not([value=""])').length) {
      $(this).find('.filter-toggle').trigger('click');
      expandFilters();
    }
  });
});


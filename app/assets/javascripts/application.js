// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(function() {
	var url = window.location.href; 
    // passes on every "a" tag 
    $("a").each(function() {
            // checks if its the same on the address bar
        if(url == (this.href)) { 
            $(this).closest("li").addClass("active");
        }
    });
});

$(function() {
	$('nav li ul').hide().removeClass('fallback');
	$('nav li').hover(
	  function () {
	    $('ul', this).stop().slideDown(100);
	  },
	  function () {
	    $('ul', this).stop().slideUp(100);
	  }
	);
})
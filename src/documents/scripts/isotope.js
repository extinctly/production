	/* Activate jQuery Isotope */

	/*	var $container = $('#isotope-items');

	$container.imagesLoaded( function(){
	  $container.isotope({
		  itemSelector : '.item'
	  });
	});
	*/
var $container = $('#isotope-items');

$(window).load(function(){
  $container.isotope({
	itemSelector : '.item'
  });
});

	var $container = $('#isotope-items').isotope({
		  itemSelector : '.item'
		});
	/* Filter function */
	$('#filters').on( 'click', 'a', function() {
	  var filterValue = $(this).attr('data-filter');
	  $container.isotope({ filter: filterValue });
	});
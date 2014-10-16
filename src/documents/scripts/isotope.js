	/* Activate jQuery Isotope */
	var $container = $('#isotope-items').isotope({
		  itemSelector : '.item'
		});
	/* Filter function */
	$('#filters').on( 'click', 'a', function() {
	  var filterValue = $(this).attr('data-filter');
	  $container.isotope({ filter: filterValue });
	});
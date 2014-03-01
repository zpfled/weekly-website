function errorMessage() {
	$('.error-msg h3').html('sorry, that didn\'t work');
	$('.error-msg').fadeIn(750).fadeOut(750);
}

// Filter Menu and Category Inputs

function filterCategories(menu) {
	if (menu.options[menu.selectedIndex].text === 'Lunch') {
		$('#lunch-cats').show();
		$('#dinner-cats').hide();
		$('#wine-cats').hide();
		$('#small-plates-cat').hide();
		$('#cocktails-cat').hide();
	} else if (menu.options[menu.selectedIndex].text === 'Dinner') {
		$('#dinner-cats').show();
		$('#lunch-cats').hide();
		$('#wine-cats').hide();
		$('#small-plates-cat').hide();
		$('#cocktails-cat').hide();
	} else if (menu.options[menu.selectedIndex].text === 'Wine') {
		$('#wine-cats').show();
		$('#lunch-cats').hide();
		$('#dinner-cats').hide();
		$('#small-plates-cat').hide();
		$('#cocktails-cat').hide();
	} else if (menu.options[menu.selectedIndex].text === 'Cocktails') {
		$('#cocktails-cat').show();
		$('#small-plates-cat').hide();
		$('#lunch-cats').hide();
		$('#dinner-cats').hide();
		$('#wine-cats').hide();
	} else {
		$('#small-plates-cat').show();
		$('#cocktails-cat').hide();
		$('#lunch-cats').hide();
		$('#dinner-cats').hide();
		$('#wine-cats').hide();
	}
}

// Asynchronous Menu Updates

$(function () {
	$('#add-item').on('submit', function(event) {
		
		event.preventDefault();

		$.ajax({
			type:		'post',
			url:		'/menu',
			data:		$(this).serialize(),
			dataType:	'html',
			
			success: function(data) {
				$('.modal').slideUp(200);
				$('.modal-backdrop').fadeToggle(200);
				$('.add-msg h3').html('success');
				$('.add-msg').fadeIn(750).fadeOut(750);
				$('#menu').html(data);
				$('#cancel').click();
			},
			error: function() {
				errorMessage();
			}
		});
	});
});

$(function () {
	$('.raise').on('submit', function(event) {
		
		event.preventDefault();
		var id = $(this).find('.id').text();
		var button = $(this);

		$.ajax({

			type:		'get',
			url:		'/' + id + '/raise',
			data:		$(this).serialize(),
			dataType:	'html',

		
			success: function(data) {
				$('.menu-msg h3').html('raised price to $' + data);
				$(button.parent().parent().find('.item-price')).html(data);
				$('.menu-msg').fadeIn(200).delay(800).fadeOut(1000);
			},
			error: function() {
				errorMessage();
			}
		});
	});
});

$(function () {
	$('.reduce').on('submit', function(event) {
		
		event.preventDefault();
		var id = $(this).find('.id').text();
		var button = $(this);

		$.ajax({

			type:		'get',
			url:		'/' + id + '/reduce',
			data:		$(this).serialize(),
			dataType:	'html',

		
			success: function(data) {
				$('.menu-msg h3').html('reduced price to $' + data);
				$(button.parent().parent().find('.item-price')).html(data);
				$('.menu-msg').fadeIn(200).delay(800).fadeOut(1000);
			},
			error: function() {
				errorMessage();
			}
		});
	});
});

$(function () {
	$('.delete').on('submit', function(event) {
		event.preventDefault();
		var id = $(this).find('.id').text();
		var button = $(this);
		
		$('.delete-confirmation').fadeToggle(200);
		
		$('#no').click(function() {
			$('.delete-confirmation').fadeOut(200);
			return false;
		});

		$('#yes').click(function() {
			$.ajax({

				type:		'get',
				url:		'/' + id + '/delete',
				data:		$(this).serialize(),
				dataType:	'html',
				success: function(data) {
					$(button.parent().parent()).remove();
					$('.delete-msg h3').html('successfully deleted ' + data);
					$('.delete-confirmation').fadeOut(200);
					$('.delete-msg').fadeIn(500).fadeOut(2000);
				},
				// error: function() {
					// errorMessage();
				// }
			});
		});
	});
});

// Parallax Scrolling Fanciness

( function( $ ) {
	
	// Setup variables
	$window = $(window);
	$slide = $('.homeSlide');
	$body = $('body');
	
    //FadeIn all sections   
	$body.imagesLoaded( function() {
		setTimeout(function() {
		      
		      // Resize sections
		      adjustWindow();
		      
		      // Fade in sections
			  $body.removeClass('loading').addClass('loaded');
			  
		}, 800);
	});
	
	function adjustWindow(){
		
		// Init Skrollr
		var s = skrollr.init();
		
		// Get window size
	    winH = $window.height();
	    
	    // Keep minimum height 550
	    if(winH <= 550) {
			winH = 550;
		} 
	    
	    // Resize our slides
	    $slide.height(winH);
	    
	    // Refresh Skrollr after resizing our sections
	    s.refresh($('.homeSlide'));
	    
	    
	}
		
} )( jQuery );

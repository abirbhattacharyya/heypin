/*
 * 	Easy Paginate 1.0 - jQuery plugin
 *	written by Alen Grakalic	
 *	http://cssglobe.com/
 *
 *	Copyright (c) 2011 Alen Grakalic (http://cssglobe.com)
 *	Dual licensed under the MIT (MIT-LICENSE.txt)
 *	and GPL (GPL-LICENSE.txt) licenses.
 *
 *	Built for jQuery library
 *	http://jquery.com
 *
 */

(function(jQuery) {
		  
	jQuery.fn.easyPaginate = function(options){

		var defaults = {				
			step: 5,
			delay: 100,
			numeric: true,
			nextprev: true,
			auto:false,
			pause:4000,
			clickstop:true,
			controls: 'pagination',
			current: 'current' 
		}; 
		
		var options = jQuery.extend(defaults, options); 
		var step = options.step;
		var lower, upper;
		var children = jQuery(this).children();
		var count = children.length;
		var next, prev;		
		var page = 1;
		var timeout;
		var clicked = false;
		
		function show(){
			clearTimeout(timeout);
			lower = ((page-1) * step);
			upper = lower+step;
			jQuery(children).each(function(i){
				var child = jQuery(this);
				child.hide();
				if(i>=lower && i<upper){setTimeout(function(){child.fadeIn('fast')}, ( i-( Math.floor(i/step) * step) )*options.delay );}
				if(options.nextprev){
					if(upper >= count) {next.fadeOut('fast');} else {next.fadeIn('fast');};
					if(lower >= 1) {prev.fadeIn('fast');} else {prev.fadeOut('fast');};
				};
			});	
			jQuery('li','#'+ options.controls).removeClass(options.current);
			jQuery('li[data-index="'+page+'"]','#'+ options.controls).addClass(options.current);
			
			if(options.auto){
				if(options.clickstop && clicked){}else{timeout = setTimeout(auto,options.pause);};
			};
		};
		
		function auto(){
			if(upper <= count){page++;show();}			
		};
		
		this.each(function(){ 
			
			obj = this;
			
			if(count>step){
				
				var pages = Math.floor(count/step);
				if((count/step) > pages) pages++;
				
				var first_child = children.first();
				var last_child = children.last();
				
				if(options.nextprev){
					prev = jQuery('<li class="nav left"><a href="javascript:;">&larr;</a></li>')
						.hide()
                                                .insertBefore(first_child)
						.click(function(){
							clicked = true;
							page--;
							show();
						});
					next = jQuery('<li class="nav right"><a href="javascript:;">&rarr;</a></li>')
						.hide()
                                                .insertAfter(last_child)
						.click(function(){
							clicked = true;			
							page++;
							show();
						});
				};
			
				show();
			};
		});	
		
	};	

})(jQuery);
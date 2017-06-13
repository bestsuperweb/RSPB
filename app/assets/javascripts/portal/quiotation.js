(function($){
    var scriptCartData = {deletedItems:{}, total: "00.00", subTotal: "00.00"}; //new Array();
    var product = 
    $.fn.extend({
        resize_input_visibility : function() {
         console.log( $(this).attr('id'))
         if($(this).val()=='true'){
             $('.has-resize-image').removeClass('hide');
         }else{
              $('.has-resize-image').addClass('hide');
              $('#quotation_image_width').val("");
              $('#quotation_image_height').val("");
         }
           
        },
        
        check_each_resize_input: function(){
            var requiredEmpty = true;
           
            $('.quotation-resize-option').each(function() {
              if(parseInt($(this).val()) > 0 ){
                   $('input[name="commit"]').removeAttr('disabled');
                    requiredEmpty = false;
               }
            });
            return requiredEmpty;
        },
        resize_option_validation : function(obj){
            
            var requiredEmpty =  $(this).check_each_resize_input();
            var resizeRadio = $('input[name="quotation\\[resize_image\\]"]:checked').val();
            
            if( requiredEmpty == true && resizeRadio =="true"){
                if($('#quotation_group_height_width').hasClass('validate-has-error')){
                    //console.log('has class parent')
                     $('input[name="commit"]').removeAttr('disabled');
                     $('input[type="submit"]').removeAttr('disabled');
                }else{
                     
                     $('#quotation_group_height_width').addClass('validate-has-error');
                }
                
                if($('#resize_option_error_msg').hasClass('has-error')){
                    
                 }else{
                      $('#resize_option_error_msg').text("You should input atleast one field of resizing \"Height\" or \"Width\"").addClass('has-error').show();
               
                 }
              
            }else{
                $('input[type="submit"]').removeAttr('disabled');
                if($('#quotation_group_height_width').hasClass('validate-has-error')){
                     $('#quotation_group_height_width').removeClass('validate-has-error');
                }
                 if($('#resize_option_error_msg').hasClass('has-error')){
                   $('#resize_option_error_msg').text(" ").removeClass('has-error').hide();
                 }
             
            }
            
        },
        before_new_quote_submission:function(){
             var resizeRadio = $('input[name="quotation\\[resize_image\\]"]:checked').val();
           if($(this).check_each_resize_input()==true && resizeRadio == "true"){
                event.preventDefault();
                $('input[name="commit"]').removeAttr('disabled');
                $(this).resize_option_validation();
                $('input[name="commit"]').removeAttr('disabled');
           }
         },
        
        rough_size_of_object: function ( value, level ) {
            var objectList = [];
            var stack = [ quotes  ];
            var bytes = 0;
            while ( stack.length ) {
                var value = stack.pop();
        
                if ( typeof value === 'boolean' ) {
                    bytes += 4;
                }
                else if ( typeof value === 'string' ) {
                    bytes += value.length * 2;
                }
                else if ( typeof value === 'number' ) {
                    bytes += 8;
                }
                else if
                (
                    typeof value === 'object'
                    && objectList.indexOf( value ) === -1
                )
                {
                    objectList.push( value );
        
                    for( var i in value ) {
                        stack.push( value[ i ] );
                    }
                }
            }
            return bytes;
        },
       clear_visited: function (value){
            if(typeof value == 'object'){
                delete value['__visited__'];
                for(var i in value){
                    $(this).clear_visited(value[i]);
                }
            }
        },
        cart_line_items_total: function(obj){
            
            for (var prop in obj) {
                // skip loop if the property is from prototype
                if(!obj.hasOwnProperty(prop)) continue;
        
                // your code
                alert(prop + " = " + obj[prop]);
            }
        },
        quotation_cart: function(){
            var exVariantArrayObj = {};
            var sku = null;
            var quote_items = {};
            var items_total = total_tax = 0;
            $(productIds.collects).each(function(i){
                var cearchVariant = productIds[i]
                var abc  =jQuery.grep(quotes, function(obj ) {
                    var variantData = obj.variants
                    var product_id = obj.id;
                    
                    $(variantData).each(function(index){
                        var vObj = variantData[index];
                        var allItemSku = vObj.sku;
                        var product_price = vObj.price;
                        if(product_price.toString().length < 3){
                           for(incr = 0; incr < 3 - product_price.toString().length; incr++){
                               product_price = "0"+ product_price.toString();
                           }
                        }
                        if(vObj.taxable){
                                vObj['item_tax'] = $(this).get_tax(vObj.price)
                        }else{
                            vObj['item_tax'] =0
                        }
                        quote_items[allItemSku] = vObj;
                        quote_items[allItemSku]['product_id'] = product_id;
                        quote_items[allItemSku]['price'] = $(this).money_format(product_price)
                        
                        if(vObj.id==productIds.collects[i].variant_id){
                            var re = /\b(\d+)(\d{2})\b/; 
                            var subst = '$1.$2';
                            var str = product_price.toString();
                            var product_price = str.replace(re, subst);
                            sku =vObj.sku;
                            vObj.product_id = product_id;
                            vObj.price = parseFloat(product_price);
                            exVariantArrayObj[sku] = vObj;
                            re = subst = str = product_price = null;
                            items_total += (vObj.price*quoteQuantity);
                            total_tax += (vObj.item_tax*quoteQuantity);
                            
                        }
                     });
                     variantData =  product_id = null;
                });
                 
            })
            
            quotes = quote_items;
            
            scriptCartData.items= exVariantArrayObj;
            cartVariation = sku.split('_');
            scriptCartData.product = cartVariation[0];
            scriptCartData.turnaround = (cartVariation[2].match(/\d/g)).join("");
            scriptCartData.volume = cartVariation[3]
            scriptCartData.currencySymbole ="£";
            scriptCartData.taxTotal = parseFloat(parseFloat(total_tax).toFixed(2));
            scriptCartData.subTotal =  parseFloat(parseFloat(items_total).toFixed(2));
            $(this).cart_item_show();
            $(this).cart_total_show();
           
        },
        get_tax:function(obj){
            return parseFloat(parseFloat($(this).money_format(obj)*(20/100)).toFixed(2));
        },
        reinetialCartItem: function(sku){
            
           
             for (var prop in obj) {
                // skip loop if the property is from prototype
                if(!obj.hasOwnProperty(prop)) continue;
        
                // your code
                alert(prop + " = " + obj[prop]);
            }
        },
        money_format:function(number){
            return parseFloat(number.toString().replace(/\b(\d+)(\d{2})\b/, '$1.$2'));
        },
        cart:function(){
            //console.log($(this).val(), $(this).attr('name'));
            var turnAroundFieldName = 'quotation[resize_image]';
            var prevTurnaround = scriptCartData.turnaround;
            var newTurnaround = $('input[name="quotation\\[resize_image\\]"]:checked').val();
            if(prevTurnaround == newTurnaround){
                       
            }else{
               $(this).reinetialCartItem();
                scriptCartData.turnaround = newTurnaround;
            }
            scriptCartData.numberOfPicsEdited = parseInt($('#quotation_quantity').val())>0? $('#quotation_quantity').val() :0;
            var searchProduct = function(test){
                return {"test":"jhfdg"};
            };
            
            //scriptCartData.total = "00.00";
            //scriptCartData.subTotal = "00.00";
           var turnAroundFieldName = null;
            //scriptCartData.subTotal = $(this).cart_line_items_total(scriptCartData.items);
            
            $(this).cart_item_show();
            $(this).cart_total_show();
            
        },
        cart_total_show:function(){
           total_html = "Sub-total: £"+scriptCartData.subTotal+"<br>"+
			"VAT (20%): £"+scriptCartData.taxTotal+"<br>"+
			"<h4>Total: £"+parseFloat(parseFloat(scriptCartData.taxTotal+scriptCartData.subTotal).toFixed(2))+"</h4>";
			$('#quotation-cart').html(total_html);
        },
        cart_turnaround_change:function(){
           
            var turnaroundSelect = $(this).val();
            var quoteQuantity = ($('#quotation_quantity').val()>0)? parseInt($('#quotation_quantity').val()) : 0;
            items_total = total_tax = 0;
            for (var prop in scriptCartData.items) {
                skuArray= prop.split('_')
                skuArray[2]=turnaroundSelect+'H';
                newSku = (skuArray.toString()).replace(/,/g, "_");
                obj = scriptCartData.items;
                if(!obj.hasOwnProperty(prop)) continue;
        
                delete scriptCartData.items[prop];
                scriptCartData.items[newSku]= quotes[newSku];
                
                if(scriptCartData.items[newSku].taxable){
                       scriptCartData.items[newSku].item_tax = $(this).get_tax(scriptCartData.items[newSku].price);
                }else{
                    scriptCartData.items[newSku].item_tax  =0
                }
                 items_total += (scriptCartData.items[newSku].price*quoteQuantity);
                 total_tax += (scriptCartData.items[newSku].item_tax*quoteQuantity);
            }
           
            scriptCartData.taxTotal = parseFloat(parseFloat(total_tax).toFixed(2));
            scriptCartData.subTotal =  parseFloat(parseFloat(items_total).toFixed(2));
            $(this).cart();
        },
        cart_from_vlume_change:function(){
            var turnaroundSelect = $(this).val();
            var quoteQuantity = ($('#quotation_quantity').val()>0)? parseInt($('#quotation_quantity').val()) : 0;
            items_total = total_tax = 0;
            for (var prop in scriptCartData.items) {
                obj = scriptCartData.items;
                if(!obj.hasOwnProperty(prop)) continue;
                
                if(scriptCartData.items[newSku].taxable){
                       scriptCartData.items[prop].item_tax = $(this).get_tax(scriptCartData.items[prop].price);
                }else{
                    scriptCartData.items[prop].item_tax  =0
                }
                 items_total += (scriptCartData.items[prop].price*quoteQuantity);
                 total_tax += (scriptCartData.items[prop].item_tax*quoteQuantity);
            }
           
            scriptCartData.taxTotal = parseFloat(parseFloat(total_tax).toFixed(2));
            scriptCartData.subTotal =  parseFloat(parseFloat(items_total).toFixed(2));
            $(this).cart();
        },
         cart_submit: function(){
             
         },
         cart_item_remove:function(key){
             
             scriptCartData.deletedItems[key]=scriptCartData['items'][key];
             delete scriptCartData['items'][key];
             
              var turnaroundSelect = $(this).val();
            var quoteQuantity = ($('#quotation_quantity').val()>0)? parseInt($('#quotation_quantity').val()) : 0;
            items_total = total_tax = 0;
            for (var prop in scriptCartData.items) {
                obj = scriptCartData.items;
                if(!obj.hasOwnProperty(prop)) continue;
                
                if(scriptCartData.items[newSku].taxable){
                       scriptCartData.items[prop].item_tax = $(this).get_tax(scriptCartData.items[prop].price);
                }else{
                    scriptCartData.items[prop].item_tax  =0
                }
                 items_total += (scriptCartData.items[prop].price*quoteQuantity);
                 total_tax += (scriptCartData.items[prop].item_tax*quoteQuantity);
            }
           
            scriptCartData.taxTotal = parseFloat(parseFloat(total_tax).toFixed(2));
            scriptCartData.subTotal =  parseFloat(parseFloat(items_total).toFixed(2));
             $(this).cart();
         },
         cart_item_show:function(){
             html ='';
            
            $.each(scriptCartData.items, function(i, item) {
               html += '<li class="list-group-item">'+
                    '<span class="badge badge-default"><strong>'+scriptCartData.currencySymbole+item.price+'</strong> <small>per image</small></span>'+
					item.name.split(' - ')[0]+	'<a href="#'+item.sku+'"><i class="entypo-cancel" data-toggle="tooltip" data-original-title="Remove this service?"></i></a>'+
					'</li>';
             })
            
             $('.list-group').append(html)
         },
         changeVal: function (v) {
            return $(this).val(v).trigger("change");
        }
        
    });
    
    
    
    $('document').ready(function(){
        
        $('#quotation-cart').quotation_cart()
        if($('#quotation_resize_image_true').is(':checked')) { 
            $('.has-resize-image').removeClass('hide'); 
        }
        
        $('.entypo-cancel').click(function(e){
            e.preventDefault();
           subset = document.getElementById("selc-service-items").getElementsByTagName("li").length;
           if(subset>1){
               if (confirm("Do you delete this service!")) {
                $(this).cart_item_remove( $(this).parent().attr('href').replace(/^#+/, ""));
                $(this).parent().parent().remove();
            }
           }else{
               alert('You are not allowed to deleted all!');
           }
            
        })
        
    });
    
     $('#quotation-cart').ready(function(){
         $('input[type=radio]').click(function() {
             if($(this).prop( "checked", true )){
                 $(this).cart_turnaround_change();
             }
          
        });
        
        $('#prev-quote div #quotation_quantity').on('keyup',function(){
             $("#quotation_quantity").changeVal($(this).val());
             $(this).cart_from_vlume_change();
         });
        
     });
 
    // Event bind to change
    $('body').on('click', '.controller-resize-image', function(){
        $(this).resize_input_visibility();
    });
    
    $('.quotation-resize-option').on('keyup paste drop',function(){
        $(this).resize_option_validation($(this));
    });
    
    
    
    
     $( "#new_quotation" ).submit(function( event, obj, error ) {
         console.log(event);
       // $("input.add_comment").removeAttr('data-disable-with');
        $(this).before_new_quote_submission();
        
     });
    
   

    
}(jQuery));


//--- add another email in setting page by AM

function close_email(event){
       $(event).parent().parent().remove();
       $(event).remove();
    }
    
jQuery(document).ready(function($) {
    
    
    $('.add-order-email').on('click', function(){
       var order_email = '<tr><td><input type="email" class="form-control" name="customer[order_email][]" value="" placeholder="i.e. john.doe@domain.com" data-validate="email"></td><td><span class="close-order-email" onclick="close_email(this)">&times;</span></td></tr>';
       $('#order-table').append(order_email);
       
    });
    
    $('.add-billing-email').on('click', function(){
       var billing_email = '<tr><td style="width: 90%;"><input type="email" class="form-control" name="customer[billing_email][]" value="" placeholder="i.e. john.doe@domain.com"></td><td><span class="close-billing-email" onclick="close_email(this)">&times;</span></td></tr>';
       $('#billing-table').append(billing_email);
      
    });
    
    $('.close-billing-email').on('cliick', function() {
        $('#field-13').remove();
        $('.add-billing-email').show();
    });
    
    $('#setting-form').on('submit', function(){
        $('#save-btn').html('<i class="entypo-cw c-refresh-animate"></i></span> Saving...'); 
    });
	
});

// -----//
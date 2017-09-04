if $("input[name='payment-option']").eq(0).is(':disabled') && $("input[name='payment-option']").eq(1).is(':disabled')
    $("input[name='payment-option']").eq(2).prop 'checked', true
    $("p.cart_vat_txt").show()
    $("#checkout-button").html 'Check Out<i class="entypo-right-open-mini"></i>'
    
$("input[name='payment-option']").on 'click', ->
    if $(this).attr('value') == "now"
        $("p.cart_vat_txt").show()
        $("#checkout-button").html 'Check Out<i class="entypo-right-open-mini"></i>'
    else
        $("p.cart_vat_txt").hide()
        $("#checkout-button").html 'Place Order<i class="entypo-right-open-mini"></i>'
        
    return
    
$('#cart-quantity').on 'change', ->
    quantity = $(this).val()
    $("input.cart-updates").val quantity
    subtotal = (unit_price*quantity).toFixed 2
    $("#cart-subtotal").html '$' + subtotal
    return
    
$('i.remove-cart-item').on 'click', ->
    if confirm 'Are you sure you want to delete it?'
        $.ajax
            type: 'POST'
            url: '/cart/clear.js',
            dataType: 'json'
            success: (res) ->
                if res.item_count == 0
                    window.location.reload()
                return
    return
    
$('#cart-edit-button').on 'click', ->
    redirect_url = $(this).attr 'data-url'
    window.location.replace redirect_url
    return
    
$('#checkout-button').on 'click', ->
    $(this).html '<i class="entypo-cw c-refresh-animate"></i> Saving...'
    payment_option = $("input[name='payment-option']:checked").val()
    if payment_option == 'now'
        $('#cart-form').submit()
    if payment_option == 'later'
        data = []
        $('.cart-updates').each (index, item) ->
          data.push $(item).attr 'data-variant'
          return
        data = data.join ','
        data = 'variants=' + data + '&quantity=' + $('#cart-quantity').val()
        data += '&customer=' + $(this).attr 'data-customer'
        data += '&quotation_id=' + $('#cart_quotation_id').html()
        data += '&return_file_format=' + $('#cart_return_file_format').html()
        data += '&set_margin=' + $('#cart_set_margin').html()
        data += '&resize_image=' + $('#cart_resize_image').html()
        data += '&image_height=' + $('#cart_image_height').html()
        data += '&image_width=' + $('#cart_image_width').html()
        data += '&message=' + $('#cart_message').html()
        data += '&additional_comment=' + $('#cart_additional_comment').html()
        
        $.ajax
            type: 'POST'
            url: $(this).attr 'data-url'
            dataType: 'json'
            data: data
            success: (res) ->
                if res.status == 'success'                    
                    $.ajax
                        type: 'POST'
                        url: '/cart/clear.js'
                        dataType: 'json'
                        success: (data) ->
                            if data.item_count == 0
                                window.location.replace res.redirect
                            return
                else
                    $('#checkout-button').html 'Check Out<i class="entypo-right-open-mini"></i>'
                return
    return
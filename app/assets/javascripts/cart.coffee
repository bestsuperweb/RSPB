$(document).on 'turbolinks:load', ->
    $("input[name='payment-option']:disabled").parent().css "text-decoration", "line-through"
    
    if $("input[name='payment-option']").eq(0).is(':disabled') && $("input[name='payment-option']").eq(1).is(':disabled')
        $("input[name='payment-option']").eq(2).prop 'checked', true
        $("p.cart_vat_txt").show()
        $("#checkout-button").html 'Check Out<i class="entypo-right-open-mini"></i>'
    
    if $("input[name='payment-option']").eq(1).is(':checked')
        $("p.cart_wallet_txt").show()
        if wallet_balance < $('#cart-quantity').val()*unit_price
            $("#checkout-button").html 'Check Out<i class="entypo-right-open-mini"></i>'
            
    $("input[name='payment-option']").on 'click', ->
        if $(this).attr('value') == "now"
            $("p.cart_wallet_txt").hide()
            $("p.cart_vat_txt").show()
            $("#checkout-button").html 'Check Out<i class="entypo-right-open-mini"></i>'
        else
            $("p.cart_vat_txt").hide()
            $("#checkout-button").html 'Place Order<i class="entypo-right-open-mini"></i>'
            if $(this).val() == 'wallet'
                $("p.cart_wallet_txt").show()
            else
                $("p.cart_wallet_txt").hide()
            
        return
        
    $('#cart-quantity').on 'change', ->
        quantity = $(this).val()
        $("input.cart-updates").val quantity
        subtotal = (unit_price*quantity).toFixed 2
        $("#cart-subtotal").html '$' + subtotal
        
        if wallet_balance >= subtotal
            result = "$#{subtotal} will be taken off from Your Wallet making the balance $#{( wallet_balance - subtotal ).toFixed(2)}."
            button = 'Place Order<i class="entypo-right-open-mini"></i>'
        else
            result = "$#{wallet_balance.toFixed(2)} will be taken off from your Wallet, and you will need to pay the balance $#{( subtotal - wallet_balance ).toFixed(2)}. VAT calculated at checkout."
            button = 'Check Out<i class="entypo-right-open-mini"></i>'
            
        $("p.cart_wallet_txt").html result
        $("#checkout-button").html button
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
            
        if payment_option == 'wallet'
            data = []
            quantity = $('#cart-quantity').val()
            subtotal = unit_price*quantity
            full_pay = true
            if subtotal > wallet_balance
                full_pay = false
                
            $('.cart-updates').each (index, item) ->
              data.push $(item).attr 'data-variant'
              return
            data = data.join ','
            data = 'variants=' + data + '&quantity=' + $('#cart-quantity').val()
            data += '&customer=' + $(this).attr 'data-customer'
            data += '&quotation_id=' + $('#cart_quotation_id').html()
            data += '&template_id=' + $('#cart_template_id').html()
            data += '&return_file_format=' + $('#cart_return_file_format').html()
            data += '&set_margin=' + $('#cart_set_margin').html()
            data += '&resize_image=' + $('#cart_resize_image').html()
            data += '&image_height=' + $('#cart_image_height').html()
            data += '&image_width=' + $('#cart_image_width').html()
            data += '&message=' + $('#cart_message').html()
            data += '&additional_comment=' + $('#cart_additional_comment').html()
            data += "&full_pay=#{full_pay}&subtotal=#{subtotal}&wallet_balance=#{wallet_balance }&unit_price=#{unit_price}"
            
            $.ajax
                type: 'POST'
                url: $(this).attr 'data-url1'
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
                        $('#checkout-button').html 'Place Order<i class="entypo-right-open-mini"></i>'
                    return
            
        if payment_option == 'later'
            data = []
            $('.cart-updates').each (index, item) ->
              data.push $(item).attr 'data-variant'
              return
            data = data.join ','
            data = 'variants=' + data + '&quantity=' + $('#cart-quantity').val()
            data += '&customer=' + $(this).attr 'data-customer'
            data += '&quotation_id=' + $('#cart_quotation_id').html()
            data += '&template_id=' + $('#cart_template_id').html()
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
        
    $('#credit-checkout-button').on 'click', ->
        $('#cart-form').submit()
        return
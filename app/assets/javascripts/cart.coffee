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
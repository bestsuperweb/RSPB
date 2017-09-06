# assets/script/billing.coffee Created by AM...

$('#check-all-unvoiced').prop 'checked', false

$('#check-all-unvoiced').on 'click', ->
    if $(this).prop 'checked'
        $('.unvoiced-individual-check').each ->
            if !$(this).prop 'checked'
                $(this).click()
            return
    else
        $('.unvoiced-individual-check').each ->
            if $(this).prop 'checked'
                $(this).click()
            return
    return
    
$('#generate_invoice').on 'click', ->
    $(this).html '<i class="entypo-cw c-refresh-animate"></i> Generating...'
    order_names = []
    url         = $(this).attr 'data-url'
    customer    = $(this).attr 'data-customer'
    
    $(".unvoiced-individual-check:checked").each ->
        order_names.push $(this).parent().parent().parent().siblings('.unvoiced-order-name').children('a').html()
        return
    
    $.ajax
        type: 'POST'
        url: url
        dataType: 'json'
        data: { 'order_names': order_names, 'customer': customer }
        success: (res) ->
            $('#generate_invoice').html 'Generate Invoice'
            if res.status == 'success'
                $('#generate_invoice_result').show().removeClass('alert-danger').addClass('alert-info').html res.result
                draft_order = res.draft
                
                new_order = "<tr><td>" + draft_order.name +
                            "</td><td>" + draft_order.created_at +
                            "</td><td>" + draft_order.total_price
                
                if draft_order.status == 'invoice_sent'
                    new_order += "</td><td><div class='label label-secondary text-uppercase'>" + draft_order.status
                else
                    new_order += "</td><td><div class='label label-success text-uppercase'>" + draft_order.status
                
                new_order += "</td><td> <a href='" + draft_order.invoice_url + 
                            "' target='blank' class='btn btn-blue'>PAY</a></td></tr>"
                
                $('#invoice_empty_row').hide()
                $('#invoice_table').prepend new_order
                $(".unvoiced-individual-check:checked").each ->
                    $(this).parent().parent().parent().parent().remove()
                    return
                if $("#unvoiced_body").children().length == 0
                    $("#unvoiced_body").prepend '<tr><td cols="5">No order found</td></tr>'
            else
                $('#generate_invoice_result').show().removeClass('alert-info').addClass('alert-danger').html res.message
            return
            
    return
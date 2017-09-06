#     assets/javascripts/dashboard.coffee Created by AM...

jQuery(document).ready ($) ->
    
    $('#resize').on 'click', ->
        $('.size-description').slideDown()
        return
        
    $('#keepsize').on 'click', ->
        $('.size-description').slideUp()
        return
        
    $('#new-order-link').on 'click', ->
        $('#templates-tbody').html '<tr><td cols="4"><h5> Loading... <i class="entypo-cw c-refresh-animate"></i></h5></td></tr>'
        $('#modal-1').modal 'show'
        url = $(this).attr 'data-url'
        url = url.replace '0', $(this).attr('data-id')
        $.ajax
          type: 'GET'
          url: url,
          dataType: 'json'
          success: (res) ->
            $('#templates-tbody').html res.data 
            return
        return
        
    $('.save-template').on 'click', ->
        
        $('#modal-2 #template_template_name').val ''
        
        products = $(this).attr 'data-products'
        products = products.split ','
        products.pop()
        i = 0
        while i < products.length
          products[i] = products[i].split('-')[0]
          i++
        products = products.join ','
        $('#modal-2 #products').attr 'placeholder', products
        
        attributes = JSON.parse $(this).attr 'data-attributes'
        $('#modal-2 #template_image_width').val attributes.image_width
        $('#modal-2 #template_image_height').val attributes.image_height
        $('#modal-2 #template_return_file_format').val attributes.return_file_format
        $('#modal-2 #template_quotation_id').val attributes.quotation_id
        $('#modal-2 #template_additional_comment').val attributes.additional_comment
        $('#modal-2 #template_message').val attributes.message
        $('#modal-2 #template_message_for_production').val attributes.message_for_production
        $('#modal-2 #template_order_id').val $(this).attr 'data-order'
        $('#modal-2 #template_customer_id').val $(this).attr 'data-customer'
        
        if attributes.resize_image == 'true'
            $('#resize').click()
        else
            $('#keepsize').click()
            
        if attributes.set_margin == 'true'
            $('#modal-2 #template_set_margin').prop 'checked', true 
        else
            $('#modal-2 #template_set_margin').prop 'checked', false
            
        $('#modal-2 #template-result').hide()
        
        return
    
    $('#template-form').on 'submit', ->
        $('#save-template').html '<i class="entypo-cw c-refresh-animate"></i> Saving...'
        return
        
    $('body').on 'click', '.rename-template', ->
        $('#rename-template-result').hide()
        $('#modal-3 form').attr 'action', $(this).attr('data-url')
        $('#modal-3 #template_template_name').val $(this).attr('data-name')
        $('#modal-3').fadeIn()
        return
    
    $('#template-rename-form').on 'submit', ->
        $('#rename-confirm').html '<i class="entypo-cw c-refresh-animate"></i> Saving...'
        return
    
    $('#modal-3 #rename-cancel').on 'click', ->
        $('#modal-3').fadeOut()
        return
    
    $('body').on 'click', '.select-template', ->
        $('#modal-4 #create-order-confirm').attr "data-id", $(this).attr("data-id")
        $('#modal-4').fadeIn()
        return 
    
    $('#modal-4 #create-order-cancel').on 'click', ->
        $('#modal-4').fadeOut()
        return
        
    $('#modal-4 #create-order-confirm').on 'click', ->
        id      = $(this).attr "data-id"
        url     = $(this).attr "data-url"
        option  = $('input[name=new-order-option]:checked').val()
        if option == 'yes'
            url = url.replace "0", id
            url = url + '?token=' + customerToken + '&hash=' + customerHash
            window.location.replace url
        if option == 'no'
            url = $(this).attr('data-url1') + '?token=' + customerToken + '&hash=' + customerHash
            window.location.replace url
        return
        
    $('.draft_delete').on 'click', ->
        if confirm 'Do you really want to delete this draft order?'
            url = $(this).attr 'data-url'
            id  = $(this).attr 'data-id'
            url = url.replace '0', id
            $.ajax
              type: 'POST'
              url: url,
              dataType: 'json'
              success: (res) ->
                if res.status == 'success'
                  $('#draft' + id).remove()
                  if $('#draft_orders_panel table tbody').children().length == 0
                      $('#draft_orders_panel').fadeOut 500
                else
                  $('#draft_delete_alert').show().removeClass('alert-success').addClass('alert-danger').html res.message  
                return
        return
        
    return
    
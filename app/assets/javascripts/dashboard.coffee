#     assets/javascripts/dashboard.coffee Created by AM...

jQuery(document).ready ($) ->
    
    $('#resize').on 'click', ->
        $('.size-description').slideDown()
        return
        
    $('#keepsize').on 'click', ->
        $('.size-description').slideUp()
        return
        
    $('.save-template').on 'click', ->
        
        $('#modal-2 #template_template_name').val ''
        
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
        $('#save-template').html '<i class="entypo-cw c-refresh-animate"></i></span> Saving...'
        return
        
    $('.rename-template').on 'click', ->
        $('#rename-template-result').hide()
        $('#modal-3 form').attr 'action', $(this).attr('data-url')
        $('#modal-3 #template_template_name').val $(this).attr('data-name')
        $('#modal-3').fadeIn()
        return
    
    $('#template-rename-form').on 'submit', ->
        $('#rename-confirm').html '<i class="entypo-cw c-refresh-animate"></i></span> Saving...'
        return
    
    $('#modal-3 #rename-cancel').on 'click', ->
        $('#modal-3').fadeOut()
        return
        
    return
    
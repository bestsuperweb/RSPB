#     assets/javascripts/dashboard.coffee Created by AM...

$(document).on 'turbolinks:load', ->
    
    # upload image in create template modal
    if $('div#dropzone-1').length
        dropzone1 = new Dropzone 'div#dropzone-1',
            url: $('#dropzone-1').attr('data-url')
            method: 'post'
            maxFiles: 1
            timeout: 18000000
            sending: (data, xhr, formData)->
                $.each JSON.parse($('#dropzone-1').attr('data-fields')), (key, value)->
                    if key == 'key'
                        formData.append key, value.replace('/', "/#{$('#dropzone-1').attr('data-id')}/")
                    else
                        formData.append key, value
            success: (file, request)->
                res_data    = $.parseXML request
                image_url   = $(res_data).find("Location").text();
                url         = $('#dropzone-1').attr 'data-url1'
                url         = url.replace '0', $('#dropzone-1').attr 'data-id'
                filename    = file.name
                filesize    = file.size
                
                $.ajax
                  type: 'POST'
                  url: url
                  data: {image_url: image_url}
                  dataType: 'json'
                  success: (response) ->
                    if response.status == 'success'
                        dropzone1.removeAllFiles()
                        $('#modal-1 .unavailable-image').hide()
                        $('#modal-1 .template_sample_image').hide()
                        if filesize/(1024*1024*5) <= 1 && ( filename.split('.').pop() == 'png' || filename.split('.').pop() == 'jpg' )
                            $('#modal-1 .template_sample_image').attr('src', ' ').addClass('loading').show()
                            $('#modal-1 .template_sample_image').attr 'src', image_url
                            $('#modal-1 .preview-image-link').attr 'href', image_url
                            $('#modal-1 .template_sample_image').on 'load', ->
                                $(this).removeClass 'loading'
                        else
                            $('#modal-1 .unavailable-image a').attr 'href', image_url
                            $('#modal-1 .unavailable-image div').html filename
                            $('#modal-1 .unavailable-image').show()
                        $('#modal-1 .deleteSample').show()
                        $('#modal-1 .upload-text').show()
                    else
                        alert response.message 
                    return        
    
    # upload image in view template modal
    if $('div#dropzone-2').length
        dropzone2 = new Dropzone 'div#dropzone-2',
            url: $('#dropzone-2').attr('data-url')
            method: 'post'
            maxFiles: 1
            timeout: 18000000
            sending: (data, xhr, formData)->
                $.each JSON.parse($('#dropzone-2').attr('data-fields')), (key, value)->
                    if key == 'key'
                        formData.append key, value.replace('/', "/#{$('#dropzone-2').attr('data-id')}/")
                    else
                        formData.append key, value
            success: (file, request)->
                res_data    = $.parseXML request
                image_url   = $(res_data).find("Location").text();
                url         = $('#dropzone-2').attr 'data-url1'
                url         = url.replace '0', $('#dropzone-2').attr 'data-id'
                filename    = file.name
                filesize    = file.size
                
                $.ajax
                  type: 'POST'
                  url: url
                  data: {image_url: image_url}
                  dataType: 'json'
                  success: (response) ->
                    if response.status == 'success'
                        dropzone2.removeAllFiles()
                        $('#modal-2 .unavailable-image').hide()
                        $('#modal-2 .template_sample_image').hide()
                        if filesize/(1024*1024*5) <= 1 && ( filename.split('.').pop() == 'png' || filename.split('.').pop() == 'jpg' )
                            $('#modal-2 .template_sample_image').attr('src', ' ').addClass('loading').show()
                            $('#modal-2 .template_sample_image').attr 'src', image_url
                            $('#modal-2 .preview-image-link').attr 'href', image_url
                            $('#modal-2 .template_sample_image').on 'load', ->
                                $(this).removeClass 'loading'
                        else
                            $('#modal-2 .unavailable-image a').attr 'href', image_url
                            $('#modal-2 .unavailable-image div').html filename
                            $('#modal-2 .unavailable-image').show()
                        $('#modal-2 .deleteSample').show()
                    else
                      alert response.message 
                    return
                    
    if $('.dropdown-toggle').length
        $('.dropdown-toggle').dropdown()
    
    $('.resize').on 'click', ->
        $(this).parent().parent().parent().children('.size-description').slideDown()
        return
        
    $('.keepsize').on 'click', ->
        $(this).parent().parent().parent().children('.size-description').slideUp()
        return
        
    $('#new-order-link').on 'click', ->
        $('#templates-tbody').html '<tr><td cols="4"><h5> Loading... <i class="entypo-cw c-refresh-animate"></i></h5></td></tr>'
        $('#update_template_result').hide()
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
        $('#modal-2 .upload-template-image').hide()
        $('#modal-2 #template_template_name').val ''
        $('#modal-2 .template_sample_image').hide()
        $('#modal-2 .deleteSample').hide()
        $('#modal-2 .unavailable-image').hide()
        
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
            $('#modal-2 #resize').click()
        else
            $('#modal-2 #keepsize').click()
            
        if attributes.set_margin == 'true'
            $('#modal-2 #template_set_margin').prop 'checked', true 
        else
            $('#modal-2 #template_set_margin').prop 'checked', false
            
        $('#modal-2 #template-result').hide()
        
        return
    
    $('#modal-2 .template-form').on 'submit', ->
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
        
    $('body').on 'click', '.template_name_link', ->
        $('#update_template_result').hide()
        
        template    = JSON.parse $(this).attr('data-template')
        url         = $('#modal-1 #edit_template_form .template-form').attr 'action'
        url         = url.replace '0', template.id
        products    = []
        variants    = JSON.parse template.product_variants
        i = 0
        while i < variants.length
          products[i] = JSON.parse(variants[i]).title
          i++
        products = products.join ','
                
        $('#modal-1 .dropzone-div').attr 'data-id', template.id
        $('#modal-1 #template_template_name').val $(this).html().trim()
        $('#modal-1 .template-form').attr 'action', url
        $('#modal-1 #products').attr 'placeholder', products
        $('#modal-1 #template_image_width').val template.image_width
        $('#modal-1 #template_image_height').val template.image_height
        $('#modal-1 #template_return_file_format').val template.return_file_format
        $('#modal-1 #template_quotation_id').val template.quotation_id
        $('#modal-1 #template_additional_comment').val template.additional_comment
        $('#modal-1 #template_message').val template.message
        $('#modal-1 #template_message_for_production').val template.message_for_production
        $('#modal-1 #template_product_variants').val template.product_variants
        $('#modal-1 #template_order_id').val template.order_id
        $('#modal-1 #template_customer_id').val template.customer_id
        
        if template.resize_image
            $('#modal-1 #resize').click()
        else
            $('#modal-1 #keepsize').click()
            
        if template.set_margin
            $('#modal-1 #template_set_margin').prop 'checked', true 
        else
            $('#modal-1 #template_set_margin').prop 'checked', false
            
        # set sample image part when clicking template name...
        dropzone1.removeAllFiles()
        $('#modal-1 .template_sample_image').hide()
        $('#modal-1 .deleteSample').hide()
        $('#modal-1 .upload-text').hide()
        $('#modal-1 .unavailable-image').hide()
        if $(this).attr('data-image') == 'true'
            $('#modal-1 .deleteSample').show()
            $('#modal-1 .upload-text').show()
            if $(this).attr('data-available') != 'true'
                $('#modal-1 .unavailable-image a').attr 'href', template.sample_image_url
                $('#modal-1 .unavailable-image div').html $(this).attr 'data-filename'
                $('#modal-1 .unavailable-image').show()
            else
                $('#modal-1 .template_sample_image').attr('src', template.sample_image_url).addClass('loading').show()
                $('#modal-1 .preview-image-link').attr 'href', template.sample_image_url
                $('#modal-1 .template_sample_image').on 'load', ->
                    $(this).removeClass 'loading'
            
        $('#modal-1 #templates-tbody').parent().hide()
        $('#modal-1 .modal-footer').hide()
        $('#modal-1 #edit_template_form').slideDown()
        return
        
    $('#back_button').on 'click', ->
        $('#modal-1 #templates-tbody').parent().show()
        $('#modal-1 .modal-footer').show()
        $('#modal-1 #edit_template_form').hide()
        $('#modal-1 .template_sample_image').attr 'src', ''
        $('#modal-1 #templates-tbody').html '<tr><td cols="4"><h5> Loading... <i class="entypo-cw c-refresh-animate"></i></h5></td></tr>'
        url = $(this).attr 'data-url'
        url = url.replace '0', $(this).attr('data-id')
        $.ajax
          type: 'GET'
          url: url,
          dataType: 'json'
          success: (res) ->
            $('#modal-1 #templates-tbody').html res.data 
            return
        return
        
    $('#update-template').on 'click', ->
        $(this).html '<i class="entypo-cw c-refresh-animate"></i>Saving...'
        return
        
    $('.deleteSample').on 'click', (event)->
        event.stopPropagation()
        if confirm 'Are you sure you want to delete this image?'
            template_id  = $(this).parent().parent().attr 'data-id'
            index        = $('.deleteSample').index $(this)
            url          = $(this).attr 'data-url'
            url          = url.replace '0', template_id
            
            $.ajax
                type: 'delete'
                url: url,
                dataType: 'json'
                success: (res) ->
                    if res.status == 'success'
                        $('.deleteSample').eq(index).parent().parent().parent().children('.preview-image-link').children('.template_sample_image').fadeOut 200
                        $('.deleteSample').eq(index).parent().parent().parent().children('.unavailable-image').fadeOut 200
                        $('.deleteSample').eq(index).fadeOut 200
                        $('#modal-1 .upload-text').fadeOut 200
                    else
                        alert res.message
                    return
        return
        
    return
    
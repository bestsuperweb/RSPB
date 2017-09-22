# quotaiont_cart.coffee created by Alex Markelz...
$(document).on 'turbolinks:load', ->
  (($) ->
    scriptCartData = 
      deletedItems: {}
      total: '00.00'
      subTotal: '00.00'
      
    product = newSku = ''
    
    enable_turnaround = ->
      if typeof turnaround != 'undefined'
        available_price = {}
        turnaround.forEach (entry) ->
          available_price[entry.handle] = entry.available_at_price
        $('input[name=\'trunaround\']').prop 'disabled', true
        $('input[name=\'trunaround\']').eq(5).prop 'disabled', false
        if scriptCartData.subTotal <= available_price[6]
          $('input[name=\'trunaround\']').eq(0).prop 'disabled', false
        if scriptCartData.subTotal <= available_price[12]
          $('input[name=\'trunaround\']').eq(1).prop 'disabled', false
        if scriptCartData.subTotal <= available_price[24]
          $('input[name=\'trunaround\']').eq(2).prop 'disabled', false
        if scriptCartData.subTotal <= available_price[48]
          $('input[name=\'trunaround\']').eq(3).prop 'disabled', false
        if scriptCartData.subTotal <= available_price[96]
          $('input[name=\'trunaround\']').eq(4).prop 'disabled', false
      return
  
    $.fn.extend
      resize_input_visibility: ->
        console.log $(this).attr('id')
        if $(this).val() == 'true'
          $('.has-resize-image').removeClass 'hide'
        else
          $('.has-resize-image').addClass 'hide'
          $('#quotation_image_width').val ''
          $('#quotation_image_height').val ''
        return
  
      check_each_resize_input: ->
        requiredEmpty = true
        $('.quotation-resize-option').each ->
          if parseInt($(this).val()) > 0
            $('input[name="commit"]').removeAttr 'disabled'
            requiredEmpty = false
          return
        requiredEmpty
  
      resize_option_validation: (obj) ->
        requiredEmpty = $(this).check_each_resize_input()
        resizeRadio = $('input[name="quotation\\[resize_image\\]"]:checked').val()
        if requiredEmpty == true and resizeRadio == 'true'
          if $('#quotation_group_height_width').hasClass('validate-has-error')
            $('input[name="commit"]').removeAttr 'disabled'
            $('input[type="submit"]').removeAttr 'disabled'
          else
            $('#quotation_group_height_width').addClass 'validate-has-error'
          if $('#resize_option_error_msg').hasClass('has-error')
          else
            $('#resize_option_error_msg').text('You should input atleast one field of resizing "Height" or "Width"').addClass('has-error').show()
        else
          $('input[type="submit"]').removeAttr 'disabled'
          if $('#quotation_group_height_width').hasClass('validate-has-error')
            $('#quotation_group_height_width').removeClass 'validate-has-error'
          if $('#resize_option_error_msg').hasClass('has-error')
            $('#resize_option_error_msg').text(' ').removeClass('has-error').hide()
        return
  
      before_new_quote_submission: ->
        resizeRadio = $('input[name="quotation\\[resize_image\\]"]:checked').val()
        if $(this).check_each_resize_input() == true and resizeRadio == 'true'
          event.preventDefault()
          $('input[name="commit"]').removeAttr 'disabled'
          $(this).resize_option_validation()
          $('input[name="commit"]').removeAttr 'disabled'
        return
  
      quotation_cart: ->
        exVariantArrayObj = {}
        sku = null
        quote_items = {}
        items_total = 0
        if typeof product_variants != 'undefined'
          $(product_variants).each (i, el) ->
            searchVariant = el.variant_id
            $(variants).each (index, element) ->
              if element.id == searchVariant
                sku = element.sku
                items_total += element.price * quoteQuantity
                exVariantArrayObj[sku] = element
              return
            return
          scriptCartData.items = exVariantArrayObj
          cartVariation = sku.split('_')
          scriptCartData.turnaround = cartVariation[cartVariation.length - 1].match(/\d/g).join('')
          scriptCartData.currencySymbole = '$'
          scriptCartData.subTotal = parseFloat(parseFloat(items_total).toFixed(2))
          $(this).cart_item_show()
          $(this).cart_total_show()
          $('input[name=trunaround][value=' + scriptCartData.turnaround + ']').prop 'checked', true
        else
          $(this).cart_item_show()
          $(this).cart_total_show()
        return
  
      money_format: (number) ->
        parseFloat number.toString().replace(/\b(\d+)(\d{2})\b/, '$1.$2')
  
      cart: ->
        turnAroundFieldName = 'trunaround'
        prevTurnaround = scriptCartData.turnaround
        newTurnaround = $('input[name="trunaround"]:checked').val()
        if prevTurnaround != newTurnaround
          scriptCartData.turnaround = newTurnaround
          
        turnAroundFieldName = null
        console.log scriptCartData
        $(this).cart_item_show()
        $(this).cart_total_show()
        return
  
      cart_total_show: ->
        if typeof product_variants != 'undefined'
          total_html = '<h4><b>Sub-total: ' + scriptCartData.currencySymbole + parseFloat(scriptCartData.subTotal).toFixed(2) + '</b></h4>' + '<p>VAT and discounts calculated at checkout.</p>'
        else
          total_html = '<h4><b>Sub-total: ...</b></h4>'
        $('#quotation-cart').html total_html
        return
  
      cart_turnaround_change: ->
        turnaroundSelect = $(this).val()
        quoteQuantity = if $('#quotation_quantity').val() > 0 then parseInt($('#quotation_quantity').val()) else 0
        items_total = 0
        for prop of scriptCartData.items
          skuArray = prop.split('_')
          skuArray[3] = turnaroundSelect + 'H'
          newSku = skuArray.toString().replace(/,/g, '_')
          obj = scriptCartData.items
          if !obj.hasOwnProperty(prop)
            continue
          delete scriptCartData.items[prop]
          $(variants).each (index, element) ->
            if element.sku == newSku
              scriptCartData.items[newSku] = element
            return
          items_total += scriptCartData.items[newSku].price * quoteQuantity
        scriptCartData.subTotal = parseFloat(parseFloat(items_total).toFixed(2))
        $(this).cart()
        return
  
      cart_from_volume_change: ->
        turnaroundSelect = $(this).val()
        quoteQuantity = if $('#quotation_quantity').val() > 0 then parseInt($('#quotation_quantity').val()) else 1
        items_total = 0
        for prop of scriptCartData.items
          obj = scriptCartData.items
          if !obj.hasOwnProperty(prop)
            continue
          items_total += scriptCartData.items[prop].price * quoteQuantity
        scriptCartData.subTotal = parseFloat(parseFloat(items_total).toFixed(2))
        $(this).cart()
        return
  
      cart_item_remove: (key) ->
        scriptCartData.deletedItems[key] = scriptCartData['items'][key]
        delete scriptCartData['items'][key]
        turnaroundSelect = $(this).val()
        quoteQuantity = if $('#quotation_quantity').val() > 0 then parseInt($('#quotation_quantity').val()) else 0
        items_total = 0
        for prop of scriptCartData.items
          obj = scriptCartData.items
          if !obj.hasOwnProperty(prop)
            continue
          items_total += scriptCartData.items[prop].price * quoteQuantity
        scriptCartData.subTotal = parseFloat(parseFloat(items_total).toFixed(2))
        $(this).cart()
        return
  
      cart_item_show: ->
        html = ''
        if typeof product_variants != 'undefined'
          $.each scriptCartData.items, (i, item) ->
            html += '<li class="list-group-item">' + '<span class="badge badge-default"><strong>' + scriptCartData.currencySymbole + item.price + '</strong> <small>per image</small></span>' + item.sku.split('_')[0].replace('-', ' ') + '<a href="#' + item.sku + '"><i class="entypo-cancel" data-toggle="tooltip" data-original-title="Remove this service?"></i></a>' + '</li>'
            return
        else
          html += '<li class="list-group-item">' + '<span class="badge badge-default"><strong>...</strong> <small></small></span>...' + '' + '</li>'
        $('.list-group').html html
        return
  
      changeVal: (v) ->
        $(this).val(v).trigger 'change'
  
    # initialize cart of quotation....
    if $('#quotation_quantity').val() == '' && typeof quoteQuantity != 'undefined'
      $('#quotation_quantity').val quoteQuantity
  
    if typeof quoteQuantity != 'undefined'
      $('#quotation-cart').quotation_cart()
      if $('input[name=trunaround]:checked').length
        $('input[name=trunaround]:checked').cart_turnaround_change()
      if $('#prev-quote div #quotation_quantity').length
        $('#prev-quote div #quotation_quantity').cart_from_volume_change()
      enable_turnaround()
  
    if $('#quotation_resize_image_true').is(':checked')
      $('.has-resize-image').removeClass 'hide'
  
    $('body').on 'click', '.entypo-cancel', (e) ->
      e.preventDefault()
      subset = document.getElementById('selc-service-items').getElementsByTagName('li').length
      if subset > 1
        if confirm('Sure you want to delete it?')
          $(this).cart_item_remove $(this).parent().attr('href').replace(/^#+/, '')
          $(this).parent().parent().remove()
      else
        alert 'At least one product needs to be there.'
      return
    
    $('#quotaion_message_more').on 'click', ->
      $('#part_quotaion_message').hide()
      $('#full_quotation_message').slideDown()
      return
        
    $('#quotaion_message_less').on 'click', ->
      $('#full_quotation_message').slideUp()
      $('#part_quotaion_message').show()
      return
  
    $('#quotation-cart').ready ->
      $('input[name=trunaround]').click ->
        if $(this).prop('checked', true)
          $(this).cart_turnaround_change()
        enable_turnaround()
        return
        
      $('#prev-quote div #quotation_quantity').on 'keyup', ->
        $('#quotation_quantity').changeVal $(this).val()
        $(this).cart_from_volume_change()
        enable_turnaround()
        return
      return
  
  
    $('body').on 'click', '.controller-resize-image', ->
      $(this).resize_input_visibility()
      return
  
    $('.quotation-resize-option').on 'keyup paste drop', ->
      $(this).resize_option_validation $(this)
      return
  
    $('#new_quotation').submit (event, obj, error) ->
      $(this).before_new_quote_submission()
      return
  
    $('.edit_quotation').on 'submit', (event, obj, error) ->
      product_variants = new Array
      for item of scriptCartData.items
        `item = item`
        product_variants.push
          'product_id': scriptCartData.items[item].product_id
          'variant_id': scriptCartData.items[item].id
          'title': scriptCartData.items[item].sku.split('_')[0].replace('-', ' ')
          'sku': scriptCartData.items[item].sku
          'price': scriptCartData.items[item].price
      product_variants_data = JSON.stringify(product_variants)
      $('#quotation_product_variants').val product_variants_data
      $('#quotation_total_price').val scriptCartData.subTotal
      $(this).before_new_quote_submission()
      return
  
    $('form.edit_quotation').on 'ajax:beforeSend', (xhr, settings) ->
      $.ajaxSetup async: false
      jQuery.post '/cart/clear.js'
      $.ajaxSetup async: true
      cartdata = {}
      data = dataAttr = ''
      for item of scriptCartData.items
        `item = item`
        console.log scriptCartData.items[item]
        cartdata.quantity = jQuery('#quotation_quantity').val()
        cartdata.id = scriptCartData.items[item].id
        data += 'updates[' + scriptCartData.items[item].id + ']=' + jQuery('#quotation_quantity').val() + '&'
      attributes = ''
      dataAttr = 'attributes[quotation_id]=' + quotationId + '&' + 'attributes[template_id]=' + templateId + '&'
      dataAttr += 'attributes[return_file_format]=' + jQuery('#quotation_return_file_format').val() + '&'
      setMargin = $('#quotation_set_margin').is(':checked')
      dataAttr += 'attributes[set_margin]=' + setMargin + '&'
      resizeRadio = $('input[name="quotation\\[resize_image\\]"]:checked').val()
      dataAttr += 'attributes[resize_image]=' + resizeRadio + '&'
  
      if resizeRadio == 'true'
        dataAttr += 'attributes[image_width]=' + jQuery('#quotation_image_width').val() + '&' + 'attributes[image_height]=' + jQuery('#quotation_image_height').val() + '&'
  
      dataAttr += 'attributes[message]=' + jQuery('#quotation_message').val() + '&'
      dataAttr += 'attributes[message_for_production]=' + jQuery('#quotation_message_for_production').val() + '&'
      dataAttr += 'attributes[additional_comment]=' + jQuery('#quotation_additional_comment').val() + '&'
      dataAttr += 'attributes[source_url]=' + window.location.href
      jQuery.post '/cart/update.js', data + dataAttr
      return
  
    $('form.edit_quotation').bind 'ajax:success', (evt, data) ->
      `var cart_url`
      data = JSON.parse(data)
      if jQuery.isEmptyObject(data.file_error)
        if typeof customerToken != 'undefined' and typeof customerHash != 'undefined'
          cart_url = data.redirect + '?token=' + customerToken + '&hash=' + customerHash
        else
          cart_url = data.redirect
        window.location.replace cart_url
      else
        $('#errors').html $(data)
      return
  
    $('form#new-order-form #edit_quotation').on 'click', ->
      jQuery.post '/cart/clear.js'
      cartdata = {}
      data = dataAttr = ''
      for item of scriptCartData.items
        `item = item`
        cartdata.quantity = jQuery('#quotation_quantity').val()
        cartdata.id = scriptCartData.items[item].id
        data += 'updates[' + scriptCartData.items[item].id + ']=' + jQuery('#quotation_quantity').val() + '&'
      attributes = ''
      dataAttr = 'attributes[quotation_id]=' + quotationId + '&' + 'attributes[template_id]=' + templateId + '&'
      dataAttr += 'attributes[return_file_format]=' + jQuery('#quotation_return_file_format').val() + '&'
      setMargin = $('#quotation_set_margin').is(':checked')
      dataAttr += 'attributes[set_margin]=' + setMargin + '&'
      resizeRadio = $('input[name="quotation\\[resize_image\\]"]:checked').val()
      dataAttr += 'attributes[resize_image]=' + resizeRadio + '&'
  
      if resizeRadio == 'true'
        dataAttr += 'attributes[image_width]=' + jQuery('#quotation_image_width').val() + '&' + 'attributes[image_height]=' + jQuery('#quotation_image_height').val() + '&'
  
      dataAttr += 'attributes[message]=' + jQuery('#quotation_message').val() + '&'
      dataAttr += 'attributes[message_for_production]=' + jQuery('#quotation_message_for_production').val() + '&'
      dataAttr += 'attributes[additional_comment]=' + jQuery('#quotation_additional_comment').val() + '&'
      dataAttr += 'attributes[source_url]=' + window.location.href
  
      $.ajax
        type: 'POST'
        url: '/cart/update.js'
        data: data + dataAttr
        dataType: 'json'
        success: (res) ->
          if res.item_count > 0
            redirect_url = $('form#new-order-form').attr('action') + '?token=' + customerToken + '&hash=' + customerHash + '&tId=' + templateId
            window.location.replace redirect_url
          return
      return
  
    return
  
  ) jQuery

return
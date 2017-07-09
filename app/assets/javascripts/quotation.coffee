
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


# Clipping path
$('input[type=radio][name=clipping_path_option]').change (e) ->
    $(".clipping_path_category_block").hide(300)
    $(".multiple_clipping_path_category_block").hide(300)
    $(".advanced_photoshop_mask_category_block").hide(300)

    if (this.value == 'clipping_path')
        $(".clipping_path_category_block").show(300)
    else if (this.value == 'multiple_clipping_path')
        $(".multiple_clipping_path_category_block").show(300)
    else if (this.value == 'advanced_photoshop_mask')
        $(".advanced_photoshop_mask_category_block").show(300)

# Retouching
$("#retouching").change (e) ->
    if $(this).is(':checked')
        $(".retouching_category_block").show(300)
    else
        $(".retouching_category_block").hide(300)

# Invisible mannequin
$("#invisible_mannequin").change (e) ->
    if $(this).is(':checked')
        $(".invisible_mannequin_category_block").show(300)
    else
        $(".invisible_mannequin_category_block").hide(300)

# Color variants
$("#color_variants").change (e) ->
    if $(this).is(':checked')
        $(".color_variants_block").show(300)
    else
        $(".color_variants_block").hide(300)

# Shadow effect
$('input[type=radio][name=shadow_effect_option]').change (e) ->
    $(".drop_shadow_category_block").hide(300)
    $(".existing_shadow_category_block").hide(300)
    $(".natural_shadow_category_block").hide(300)
    $(".floating_shadow_category_block").hide(300)
    $(".mirror_effect_category_block").hide(300)

    if (this.value == 'drop_shadow')
        $(".drop_shadow_category_block").show(300)
    else if (this.value == 'existing_shadow')
        $(".existing_shadow_category_block").show(300)
    else if (this.value == 'natural_shadow')
        $(".natural_shadow_category_block").show(300)
    else if (this.value == 'floating_shadow')
        $(".floating_shadow_category_block").show(300)
    else if (this.value == 'mirror_effect')
        $(".mirror_effect_category_block").show(300)

# $(".figure").popover({
#     trigger: "hover",
#     container: 'body',
#     placement: 'bottom',
#     html: true,
#     title: 'Category 1 more samples',
#     content: $('#popover-content').html()
# })

$("#add_another_variant").click ->
    tr = $('.color_variant_tr_clone:last')
    clone = tr.clone()
    clone.find(':text').val('')
    tr.after(clone)

$("#add_another_copy").click ->
    div = $('.main_copy_clone:last')
    clone = div.clone()
    clone.find(':text').val('')
    count = $('.main_copy_clone').length+1
    clone.find('h4').text('Copy '+count)
    clone.find('.resize_image_question').remove()
    div.after(clone)

$(".radio-with-image label").click ->
    service = $(this).find('input').attr('name')
    option = $(this).find('input').attr('value')
    #alert(service+'/'+option)
    $("#modal-more-samples .modal-body").html('Loading..')
    $("#modal-more-samples").modal()
    $.ajax '/admin/quotations_samples',
        type: 'GET'
        data: {'service': service, 'option': option}
        dataType: 'html'
        error: (jqXHR, textStatus, errorThrown) ->
            $("#modal-more-samples .modal-body").html("AJAX Error: #{textStatus}")
        success: (data, textStatus, jqXHR) ->
            $("#modal-more-samples .modal-body").html(data)

$ ->
    $("#modal-more-samples .modal-body").css('overflow': 'auto')

$ ->
    $(document).on 'mouseover', '.category-sample-image', ->
        #alert('aa');
(function($){
    
    $.fn.extend({
        calculate : function() {
           var tn= $('.top-up-number').val();
           var tbVal= $('.top-up-bundles option:selected').val();
           var tbText= $('.top-up-bundles option:selected').text();
           var bundlTextArr = tbText.split(" ");
           var currency = $.trim(bundlTextArr[0]).substr(0,1);
           var creditAmount = $.trim(bundlTextArr[0]).substr(1);
           var topUpTotal = creditAmount*tn;
           var calculatedResult = "Pay "+currency+ topUpTotal.toFixed(2)+" "+bundlTextArr[1]
           $('.top-up-total').val(calculatedResult)
           
           
        }
    });
    
    // Event bind to change
    $('body').on('change', '.top-up-bundles, .top-up-number', function(){
        
       $(this).calculate();
    });
    
    // Event bind to click
    $('body').on('click', '.input-spinner button', function(){
        
       $(this).calculate();
    });
    
     // Event bind to click
    $('body').on('keyup', '.top-up-number', function(){
       $(this).calculate();
       
    });
    
    $(".top-up-number").keydown(function (e) {
         // Allow: backspace, delete, tab, escape, enter and .
         console.log(e.keyCode)
        if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
             // Allow: Ctrl+A, Command+A
            (e.keyCode === 65 && (e.ctrlKey === true || e.metaKey === true)) || 
             // Allow: home, end, left, right, down, up
            (e.keyCode >= 35 && e.keyCode <= 40)) {
                 // let it happen, don't do anything
                 if(e.keyCode==8 || e.keyCode == 46){
                     console.log("val"+ $.trim($(this).val()).length);
                     if( $.trim($(this).val()).length== 1 ){
                          e.preventDefault();
                          return false;
                     }else{
                          return true;
                     }
                       
                 }else{
                      return false;
                 }
                
        }
        // Ensure that it is a number and stop the keypress
        if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
           e.preventDefault();
        }
        //$(this).val( $.trim($(this).val()) == '' ? 1 : $(this).val());
    });
    
    $("#pay-top-up-btn").click(function(){
        //window.location.href='/cart/30681533067:1'+tbVal+":"+tn;
        var tn= $('.top-up-number').val();
        var tbVal= $('.top-up-bundles option:selected').val();
        window.location.href='/cart/'+tbVal+":"+tn;
    });
     
    
}(jQuery));



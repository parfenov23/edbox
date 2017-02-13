var max_time_ads_popup = 15;

var run_ads_popup = function(){
  var last_date_string = $.session.get("ads_popup_close");
  if (last_date_string == undefined) max_time_ads_popup = 0;
  if (reside_last_date_close_ads("ads_popup_close") >= max_time_ads_popup) {
    $("#ads_popup").css({display: 'flex'});
    ads_footer_hide();
    setTimeout(function(){
      $("#ads_popup .close").show();
    }, 5000);
  }
}

pageLoad(function(){
  $(document).on('click', '.js_completeAttachment', run_ads_popup);
  $(document).on('click', "#ads_popup .close", function(){
    var curr_date = new Date();
    $("#ads_popup").hide();
    $.session.set("ads_popup_close", curr_date);
  });
})
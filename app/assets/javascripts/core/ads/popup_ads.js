var max_time_ads_popup = 15;

var time_show_close_popup_ads = function(){
  return 5000;
}

var run_ads_popup = function(){
  var last_date_string = $.session.get("ads_popup_close");
  if (last_date_string == undefined) max_time_ads_popup = 0;
  if (reside_last_date_close_ads("ads_popup_close") >= max_time_ads_popup) {
    $("#ads_popup").css({display: 'flex'});
    start_countdown_close_popup_ads();
    ads_footer_hide();
    setTimeout(function(){
      $("#ads_popup .close").show();
    }, time_show_close_popup_ads());
  }
}

var start_countdown_close_popup_ads = function(){
  var block = $("#ads_popup .cssload-container");
  var start_time = time_show_close_popup_ads()/1000;
  block.show();
  var int_back_time = setInterval(function(){
    start_time -= 1
    if (start_time >0){
      block.find(".time").text(start_time)
    }
  }, 1000);
  setTimeout(function(){
    block.hide();
    clearInterval(int_back_time);
  }, time_show_close_footer_ads());
}

pageLoad(function(){
  $(document).on('click', '.js_completeAttachment', run_ads_popup);
  $(document).on('click', "#ads_popup .close", function(){
    var curr_date = new Date();
    $("#ads_popup").hide();
    $.session.set("ads_popup_close", curr_date);
  });
})
var max_time_ads_footer = 0;

var time_show_close_footer_ads = function(){
  return 5000;
};

// фиксирование рекламного блока
var func_ads_press = function(){
  if (ads_footer_is_visible()){
    var px = view_px_block($("footer"));
    var error_px = 83;
    if ($(window).width() <= 800 ) error_px = 80;
    if (px + error_px >= 0) {
      $(".ads__footer").removeClass("fixed_bottom");
      $("footer").css({'margin-top': '0px'});
    }else{
      $(".ads__footer").addClass("fixed_bottom");
      $("footer").css({'margin-top': $(".ads__footer").outerHeight()+"px"});
    }
  }
}
///

var fixed_bottom_ads = function(){
  $( window ).scroll(function() {
    func_ads_press();
  });
}

var ads_footer_hide = function(){
  var time = new Date();
  $.cookie("ads_footer_close", time);
  $(".ads__footer").hide();
  $("footer").css({'margin-top': '0'});
  $(".ads__footer .close").hide();
  auto_start_ads_footer();
}

var reside_last_date_close_ads = function(type){
  var last_date_string = $.cookie(type);
  var reside = 0;
  if (last_date_string != undefined){
    if (type == "ads_footer_close") max_time_ads_footer = 5;
    if (type == "ads_popup_common") max_time_ads_popup_common = 10;
    var last_date = new Date(last_date_string);
    var curr_time = new Date();
    reside = Math.round((last_date - curr_time)*(-1)/1000/60)
  }
  return reside
}

var ads_footer_is_visible = function(){
  return $(".ads__footer:visible").length == 1
}

var start_countdown_close_footer_ads = function(){
  var block = $(".ads__footer .cssload-container");
  var start_time = time_show_close_footer_ads()/1000;
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

var start_ads = function(){
  fixed_bottom_ads();
  $(".ads__footer").show();
  func_ads_press();
  start_countdown_close_footer_ads();
  setTimeout(function(){
    $(".ads__footer .close").show();
  }, time_show_close_footer_ads());
}

var auto_start_ads_footer = function(){
  $(".ads__footer").hide();
  var last_reside = reside_last_date_close_ads("ads_footer_close")*60000;
  var reside_start = ((max_time_ads_footer*60000) - last_reside);
  setTimeout(function(){
    start_ads();
  }, reside_start);
}

pageLoad(function () {
  if (reside_last_date_close_ads("ads_footer_close") >= max_time_ads_footer){
    start_ads();
  }else{
    auto_start_ads_footer();
  }

  $(document).on('click', '.ads__footer .close', ads_footer_hide);
});
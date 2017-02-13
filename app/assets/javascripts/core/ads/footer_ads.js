var max_time_ads_footer = 0;

var fixed_bottom_ads = function(){
  $( window ).scroll(function() {
    if (ads_footer_is_visible()){
      var px = view_px_block($("footer"));
      var error_px = 20;
      if ($(window).width() <= 800 ) error_px = 80;
      if (px + error_px >= 0) {
        $(".ads__footer").removeClass("fixed_bottom");
        $("footer").css({'margin-top': '0px'});
      }else{
        $(".ads__footer").addClass("fixed_bottom");
        $("footer").css({'margin-top': '160px'});
      }
    }
  });
}

var ads_footer_hide = function(){
  var time = new Date();
  $.session.set("ads_footer_close", time);
  $(".ads__footer").hide();
  $("footer").css({'margin-top': '0'});
  auto_start_ads_footer();
}

var reside_last_date_close_ads = function(type){
  var last_date_string = $.session.get(type);
  var reside = 0;
  if (last_date_string != undefined){
    if (type == "ads_footer_close") max_time_ads_footer = 5;
    var last_date = new Date(last_date_string);
    var curr_time = new Date();
    reside = Math.round((last_date - curr_time)*(-1)/1000/60)
  }
  return reside
}

var ads_footer_is_visible = function(){
  return $(".ads__footer:visible").length == 1
}

var start_ads = function(){
  fixed_bottom_ads();
  $(".ads__footer").show();
  setTimeout(function(){
    $(".ads__footer .close").show();
  }, 5000);
}

var auto_start_ads_footer = function(){
  $(".ads__footer").hide();
  var reside_start = (max_time_ads_footer*60000) - (reside_last_date_close_ads("ads_footer_close")*60000);
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
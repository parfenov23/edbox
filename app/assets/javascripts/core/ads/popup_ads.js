var max_time_ads_popup_common = 0;
var time_show_close_popup_ads = function(){
  return 5000;
}


// popup common
var time_show_close_popup_ads_common = function(){
  return 5000;
};

var ads_popup_common_hide = function(){
  var time = new Date();
  $.session.set("ads_popup_common", time);
  // $("#ads_popup_common").hide();
  $("#ads_popup_common").removeClass("show");
  $("#ads_popup_common .close").hide();

  auto_start_ads_popup_common();
}

var start_countdown_close_popup_ads_common = function(){
  var block = $("#ads_popup_common .cssload-container");
  var start_time = time_show_close_popup_ads_common()/1000;
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
  }, time_show_close_popup_ads_common());
}

var auto_start_ads_popup_common = function(){
  $("#ads_popup_common").removeClass("show");
  var last_reside = reside_last_date_close_ads("ads_popup_common")*60000;
  var reside_start = ((max_time_ads_popup_common*60000) - last_reside);
  setTimeout(function(){
    start_ads_popup_common();
  }, reside_start);
}

var start_ads_popup_common = function(){
  // $("#ads_popup_common").css({display: 'flex'});
  setTimeout(function(){
    $("#ads_popup_common").addClass("show");
  }, 500);
  pause_video_vimeo();
  start_countdown_close_popup_ads_common();
  setTimeout(function(){
    $("#ads_popup_common .close").show();
  }, time_show_close_popup_ads_common());
}

/////popup common

var run_ads_popup = function(){
  var last_date_string = $.session.get("ads_popup_close");
  var max_time_ads_popup = $("#ads_popup").data("time_line");
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
  if ($("#ads_popup").length){
    $(document).on('click', '.js_completeAttachment', run_ads_popup);
    $(document).on('click', "#ads_popup .close", function(){
      var curr_date = new Date();
      $("#ads_popup").hide();
      $.session.set("ads_popup_close", curr_date);
    });
  }

  if ($("#ads_popup_common").length){
    if($(".js_completeAttachment, #ads_popup").length != 2){
      if (reside_last_date_close_ads("ads_popup_common") >= max_time_ads_popup_common){
        start_ads_popup_common();
      }else{
        auto_start_ads_popup_common();
      }
      $(document).on('click', '#ads_popup_common .close', ads_popup_common_hide);
    }
  }


})
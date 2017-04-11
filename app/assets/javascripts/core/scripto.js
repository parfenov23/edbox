// var addCssIcon = function(){
//   var css=""
//   $("#scripto .card_categories .item i.icon").each(function(n, e){
//     var icon = $(e).data('icon')
//     var id = icon.replace("\e", "");
//     css += "#scripto .card_categories .item .icon i." + id + "::before{ content: '" + icon + "'; }"
//     $(e).addClass(id);
//   });
//   $("body").append("<style>" + css + "</style>");
// }

var open_card_item_category = function(){
  $("#scripto .card_categories .item").removeClass("active");
  var curr_card_category = $("#scripto .card_categories .item[data-card_category_id='"+ $(this).data('card_category_id') +"']")
  curr_card_category.addClass("active");
  $("header .page__title").hide();
  $("#scripto .card_info_block").hide();
  $("#scripto .card_info_block[data-card_category_id='" + $(this).data('card_category_id') + "']").show();
  $("header .left-col .crumbs").remove();
  $(".card_items .item.back_item").hide();
  $(".card_welcome").hide();
  $("header .left-col .page__children").before($("<ul class='crumbs'><li class='js_openCategoryScripto' data-card_category_id='" + 
    $(this).data("card_category_id") + "'>"+ curr_card_category.find(".title").text() +"</li></ul>"));
  $("header .left-col .js_openCategoryScripto").on('click', open_card_item_category)
}

var open_card_item = function(){
  if (!$(this).data('open')){
    $("#scripto .card_info_block").hide();
    $("#scripto .card_items .item.back_item").css('display', 'flex');
    var id = $(this).data('card_id') ;
    var data_type_prev = "item"
    if ($(this).data('first_card')){
      data_type_prev = "category"
    }
    // $("header .left-col .crumbs li:last").append("<span class='arrow-right'></span>");
    if ($(this).data('add_crumbs')){
      $("header .left-col .crumbs").append($("<li class='js_openCardScripto' data-card_id=" + 
        $(this).data("card_id") + " data-first_card="+ $(this).data("first_card") +
        " data-open="+ $(this).data("open") +">" + 
        $(this).find(".title").text() + "</li>"));
    }
    $(".js_openCardScripto").unbind('click');
    $(".js_openCardScripto").on('click', open_card_item);
    if($(this).prop("tagName") == "LI"){
      $(this).nextAll().remove();
    }
    $("#scripto .card_items .item.back_item").data('prev_type', data_type_prev)
    $("#scripto .card_info_block[data-card_item_id='" + id + "']").show();
  }
}

var back_item = function(){
  var first_vis = $("#scripto .card_items .card_info_block .item:visible:first").closest(".card_info_block");
  var id = first_vis.data("card_item_id");
  $("#scripto .card_info_block").hide();
  $("header .left-col .crumbs li:last").remove();
  if ($(this).data('prev_type') == "category"){
    find_category_id = $("#scripto .card_info_block .item[data-card_id='" + id + "']").closest(".card_info_block").data('card_category_id');
    $("#scripto .card_info_block[data-card_category_id='" + find_category_id + "']").show();
    $(this).hide();
  }else{
    var find = $("#scripto .card_info_block .item[data-card_id='" + id + "']")
    var parent_id = find.closest(".card_info_block").data('card_item_id');
    var find_block = $("#scripto .card_info_block[data-card_item_id='" + parent_id + "']")
    if (parent_id != undefined) {
      find_block.show();
    }else{
      var category_id = find.closest(".card_info_block").data('card_category_id')
      $("#scripto .card_info_block[data-card_category_id='" + category_id + "']").show();
      $(this).hide();
    }
    if (find.data('open')){
      $(this).data('open', "category");
    }
  }
}

pageLoad(function(){
  // addCssIcon();
  $("#scripto .card_item__description .inner_content .close").on('click', function(){
    $(this).closest(".card_item__description").hide();
  });

  $("#scripto .card_items .card_info_block .item, .js_openCardScripto").on('click', open_card_item);

  $("#scripto .card_items .item[data-open='true']").on('click', function(){
    var btn = $(this);
    btn.addClass("open_animate");
    
    setTimeout(function(){
      btn.closest(".card_info_block").find(".card_item__description").css('display', 'flex');
      btn.removeClass("open_animate");
    }, 500);
    
  });

  $("#scripto .js__openPopupEditProfile").on('click', function(){
    $("#inner_scripto .popupProfile").css("display", "flex");
  });

  $("#inner_scripto .popupProfile").on('click', function(e){
    if( $(e.target).hasClass("popupProfile") ) $("#inner_scripto .popupProfile").hide();
  });

  $("#inner_scripto .popupProfile .btn").on('click', function(){
    setTimeout(function(){
      window.location.reload();
    }, 500);
  })


  $("#scripto .card_items .item.back_item").on('click', back_item);

  $(".js_openCategoryScripto").on('click', open_card_item_category)
});
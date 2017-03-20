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
  $("#scripto .card_info_block").hide();
  $("#scripto .card_info_block[data-card_category_id='" + $(this).data('card_category_id') + "']").show();
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
    $("#scripto .card_items .item.back_item").data('prev_type', data_type_prev)
    $("#scripto .card_info_block[data-card_item_id='" + id + "']").show();
  }
}

var back_item = function(){
  var first_vis = $("#scripto .card_items .card_info_block .item:visible:first").closest(".card_info_block");
  var id = first_vis.data("card_item_id");
  $("#scripto .card_info_block").hide();
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

  $("#scripto .card_items .card_info_block .item").on('click', open_card_item);

  $("#scripto .card_items .item[data-open='true']").on('click', function(){
    $(this).closest(".card_info_block").find(".card_item__description").css('display', 'flex');
  });


  $("#scripto .card_items .item.back_item").on('click', back_item);

  $("#scripto .card_categories .item").on('click', open_card_item_category)
})
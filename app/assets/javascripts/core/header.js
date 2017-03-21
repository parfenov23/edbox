var openArticleNews = function(){
    var id = $(this).closest('li').data('id');
    $(this).closest(".menu__apps").hide();
    $("#js-news").addClass('show');
    $("#js-news .hidden__block.is__active").removeClass('.is__active');
    $("#js-news .item[data-id='"+ id +"'] .hidden__block").addClass('is__active');
};

var readNews = function(){
    var block = $(this).closest('li');
    var id = block.data('id');
    $.ajax({
        type: 'POST',
        url : '/api/v1/news/'+ id +'/read'
    }).success(function (data) {
        var parent_block = block.closest('.js_openNotifyNewsList');
        var block_count = parent_block.find(".notification__with-qty");
        var n_count = parseInt(block_count.text());
        if (n_count <= 1){
            block_count.hide();
        }else{
            block_count.text( n_count - 1 );
        }
        block.removeClass("no_read");
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

$(document).ready(function(){
    $(".js_openNotifyNewsList").click(function(event){
        var evt = evt || event;
        var target = evt.target || evt.srcElement;
        if ($(target).closest(".menu__apps").length == 0){
            var btn = $(this);
            btn.find(".menu__apps").toggle()
        }

    });
    $(document).click(function(event){
        var evt = evt || event;
        var target = evt.target || evt.srcElement;
        if ($(target).closest(".js_openNotifyNewsList").length == 0 || $(target).hasClass('js_closePopupNews')){
            $(".js_openNotifyNewsList .menu__apps").hide()
        }
    });

    $(document).on('click', '.js_openArticleNews', openArticleNews);
    $(document).on('click', '.js_readNews', readNews);
});

  $(document).ready(function(){
    // var path = (location.pathname+location.search);
    // var curr_li = $('#study_popup').find("a[href='"+ path +"']");
    // if (curr_li.length && path != "/courses"){
    //     $('#open_study_popup span').text(curr_li.text());
    //     $('#open_study_popup').addClass("active_page");
    //     curr_li.addClass("active");
    // }

    $('#open_study_popup').click(function(){
      var btn = $(this);
      var block_popup = $("#study_popup");
      if (!block_popup.hasClass("open")){
        btn.addClass("active");
        btn.find(".icon_btn").removeClass("down").addClass("up");
        block_popup.css('left', btn.position().left + "px");
        block_popup.fadeIn("slow");
        block_popup.addClass("open");
      }else{
        btn.removeClass("active");
        btn.find(".icon_btn").removeClass("up").addClass("down");
        block_popup.fadeOut("slow");
        block_popup.removeClass("open");
      }
    });

    $(document).on('click', function(e) {
      if (!$(e.target).closest("#study_popup").length && !$(e.target).closest("#open_study_popup").length ) {
        $('#open_study_popup').removeClass("active");
        $('#open_study_popup .icon_btn').removeClass("up").addClass("down");
        $('#study_popup').fadeOut("slow");
        $('#study_popup').removeClass("open");
      }
      e.stopPropagation();
    });
  });
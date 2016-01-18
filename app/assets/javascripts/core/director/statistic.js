var js_openPopupUserStatistic = function(){
    var user_id = $(this).data('id');
    var popup = $(".pop_up_confirm.all_user_statistics");
    popup.addClass('is__active');
    popup.find("[data-user_id="+ user_id +"]").show();
};

pageLoad(function () {
    $(document).on('click', '.js_openPopupUserStatistic', js_openPopupUserStatistic);
    $(document).on('click', '.pop_up_confirm.all_user_statistics', function(e){
        if($(e.target).hasClass('all_user_statistics')){
            $(".pop_up_confirm.all_user_statistics").removeClass('is__active');
        }
    })
});

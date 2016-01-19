var js_openPopupUserStatistic = function(){
    var user_id = $(this).data('id');
    var popup = $(".pop_up_confirm.all_user_statistics");
    popup.addClass('is__active');
    popup.find("[data-user_id="+ user_id +"]").show();
};

var statisticPopupTabs = function(){
    var btn = $(this);
    var type = btn.data('type');
    var course_list = btn.closest('.inner').find('.courses_info_statistic');
    if (!btn.hasClass('is__active')){
        btn.closest('ul').find('li').removeClass('is__active');
        btn.addClass('is__active');
        course_list.find('li').removeClass('active');
        course_list.find('li[data-type='+ type +']').addClass('active');
    }
};

pageLoad(function () {
    $(document).on('click', '.js_openPopupUserStatistic', js_openPopupUserStatistic);
    $(document).on('click', '.pop_up_confirm.all_user_statistics', function(e){
        if($(e.target).hasClass('all_user_statistics')){
            $(".pop_up_confirm.all_user_statistics").removeClass('is__active');
        }
    });
    $(document).on('click', '.js_statisticPopupTabs li', statisticPopupTabs)
});

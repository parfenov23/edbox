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

var exportStatistic = function(){
    var btn = $(this);
    window.location.href = '/director/statistic/' + btn.data('type') + '?group=' + btn.data('group');
};

pageLoad(function () {
    $(document).on('click', '.js_openPopupUserStatistic', js_openPopupUserStatistic);
    $(document).on('click', '.pop_up_confirm.all_user_statistics', function(e){
        if($(e.target).hasClass('all_user_statistics')){
            var popup = $(".pop_up_confirm.all_user_statistics");
            popup.removeClass('is__active');
            popup.find(".director__statistic__user_info").hide();
        }
    });
    $(document).on('click', '.js_statisticPopupTabs li', statisticPopupTabs)
    $(document).on('click', '.js_exportStatistic', exportStatistic);

    if ($(".director__stat_table .course__title__list .item").length < 5) $(".director__stat_table .table__paginator").hide();
});

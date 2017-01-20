var openHiddenList = function (e) {
    e.preventDefault();
    if ($(e.target).hasClass("js_openHiddenList")){
        $(this).find(".block_hidden_list").show();
    }
    $(this).find(".ripple-wrapper").remove();
};

var closeHiddenList = function () {
    $(this).closest(".block_hidden_list").hide();
};

var regGroupOnWebinar = function (e){
    var btn = $(e.target);
    if (btn.hasClass("js_regGroupOnWebinar")){
        show_error("Подождите идет регистрация сотрудников на вебинар", 0);
        $.ajax({
            type: 'POST',
            url : '/api/v1/webinars/' + btn.data('id') + "/event_reg_group",
            data: {group_id: btn.data('group_id')}
        }).success(function (data) {
            if (data.success) {
                show_error("Группа зарегистрирована на вебинар", 3000);
                btn.find(".remove").removeClass("hide");
            }else{
                show_error("Сотрудники уже зарегистрированы на вебинар", 3000);
            }
        }).error(function () {
            show_error('Произошла ошибка', 3000);
        });
    }
};

var unregGroupFromWeinar = function(){
    show_error("Подождите идет удаление группы с вебинар", 0);
    var btn = $(this);
    $.ajax({
        type: 'POST',
        url : '/api/v1/webinars/' + btn.data('id') + "/event_unreg_group",
        data: {group_id: btn.data('group_id')}
    }).success(function (data) {
        if (data.success) {
            show_error("Группа удалена с вебинара", 3000);
            btn.addClass("hide");
        }else{
            show_error("Группа еще не зарегистрирована на вебинар", 3000);
        }
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

pageLoad(function () {
    $(document).on('click', '.js_openHiddenList', openHiddenList);
    $(document).on('click', '.js_openHiddenList .block_hidden_list li', closeHiddenList);
    $(document).on('click', '.js_regGroupOnWebinar', regGroupOnWebinar);
    $(document).on('click', '.js_unregGroupFromWeinar', unregGroupFromWeinar);
});
var clickItemMember = function () {
    var parent_member = $(this).closest(".members__in_system");
    var count_select = parent_member.find("li.is__choosen").length;
    var arr_1 = ["пользователь", "пользователя", "пользователей"];
    var arr_2 = ["Выбран", "Выбранно", "Выбранно"];
    var text_title = declOfNum(count_select, arr_2) + " " + count_select + " " + declOfNum(count_select, arr_1);
    $(".js__multi__action .title").text(text_title)
};

var deleteMemberToGroup = function (group_id) {
    var form = $("ul.members__in_system li.is__choosen");
    var number_ids = $.map(form, function (n) {
        return $(n).data('id');
    });
    $.ajax({
        type: 'POST',
        url : '/api/v1/groups/' + group_id + '/remove_user',
        data: {user_id: number_ids}
    }).success(function () {
        form.remove();
        $(".js__multi__action.multi__choice").removeClass("is__active");
        show_error('Пользователи удаленны из группы', 3000);
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

pageLoad(function () {
    $(document).on('click', ".js_clickItemMember", clickItemMember);
    $(document).on('click', ".js__multi__action .js_removeUserToGroup", function () {
        var btn = $(this);
        confirm("Вы действительно хотите удалить участников из гуппы?", function () {
            deleteMemberToGroup(btn.data("id"));
        })
    });
});
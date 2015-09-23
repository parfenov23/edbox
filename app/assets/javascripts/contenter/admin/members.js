var inviteLeadingUser = function () {
    if (! $('.membersAdminLeading  .invited__item').length == 0){
        var data = $.map($('.membersAdminLeading  .members__invite .invited__item .email'), function (el) {
            return $(el).text();
        });
        $.ajax({
            type: 'POST',
            url : '/api/v1/users/invite',
            data: {emails: data, leading: true}
        }).success(function () {
            show_error('Приглашения отправлены', 3000);
            setTimeout(function () {
                location.reload();
            }, 1500);

        }).error(function () {
            show_error('Произошла ошибка отправки', 3000);
        });
    }
};

var removeUserToLeading = function () {
    var form = $("ul.members__in_system li.is__choosen");
    var number_ids = $.map(form, function (n) {
        return $(n).data('id');
    });
    $.ajax({
        type: 'POST',
        url : '/api/v1/users/remove_user_leading',
        data: {id: number_ids}
    }).success(function () {
        form.remove();
        $(".js__multi__action.multi__choice").removeClass("is__active");
        show_error('Ведущие удалены', 3000);
    }).error(function () {
        show_error('Произошла ошибка отправки', 3000);
    });
};

pageLoad(function () {
    $(document).on('click', '.membersAdminLeading .js_inviteLeadingUser', inviteLeadingUser);
    $(document).on('click', ".js__multi__action .js_removeUserToLeading", function () {
        confirm("Вы действительно хотите удалить ведущих?", function () {
            removeUserToLeading();
        })
    });
});
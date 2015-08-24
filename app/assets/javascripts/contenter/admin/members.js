var inviteLeadingUser = function () {
    if (! $('#membersAdminLeading  .invited__item').length == 0){
        var data = $.map($('#membersAdminLeading  .members__invite .invited__item .email'), function (el) {
            return $(el).text();
        });
        $.ajax({
            type: 'POST',
            url : '/api/v1/users/invite',
            data: {emails: data, leading: true}
        }).success(function () {
            show_error('Приглашения отправлены', 3000);
            setTimeout(function(){
                location.reload();
            }, 1500);

        }).error(function () {
            show_error('Произошла ошибка отправки', 3000);
        });
    }
};

var removeUserToLeading = function () {
    var btn = $(this);
    $.ajax({
        type: 'POST',
        url : '/api/v1/users/'+ btn.data('id') +'/remove_user_leading'
    }).success(function () {
        show_error('Ведущий удален', 3000);
        btn.closest(".members__in_system-item").remove();
    }).error(function () {
        show_error('Произошла ошибка отправки', 3000);
    });
};

pageLoad(function () {
    $(document).on('click', '#membersAdminLeading .js_inviteLeadingUser', inviteLeadingUser);
    $(document).on('click', '#membersAdminLeading .js_removeUserToLeading', removeUserToLeading);
});
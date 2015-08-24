invitedEmpty = function () {
    if ($('.invited__item').length == 0){
        $('.members__invite .invited').hide();
    }
};

invitedMemberDelete = function () {
    $(document).on('click', '.members__invite .cancel', function () {
        console.log($(this));
        console.log($(this).closest('.invited__item'));
        $(this).closest('.invited__item').remove();
        invitedEmpty();
    });
};

appendMember = function (member) {
    var emailRegexp = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;

    if (emailRegexp.test(member) == false){
        if (member.length > 0){
            show_error('Неправильный email', 3000);
        }
    } else {
        if ($(".invited__item div[data-email='" + member + "']").length == 0){
            $('.members__invite .invited').show();
            $('.members__invite .input').val('');
            $('<li class="invited__item">' +
                '<div class="email" data-email="' + member + '">' + member + '</div>' +
                '<div class="cancel">×</div>' +
                '</li>')
                .appendTo('.members__invite .invited');
        } else {
            show_error('Email уже добавленн', 3000);
            $('.members__invite .input').val('');
        }
    }


};

inviteMember = function () {

    $('.members__invite .input').focus(function () {
        $(window).keydown(function (e) {
            code = e.keyCode || e.which;
            if (code == 32){
                e.preventDefault();
                var member = $('.members__invite .input').val();
                appendMember(member);
            }
        });
    });
};

sendInvintations = function () {
    $('.members__invite .js_inviteUser').click(function () {
        var member = $('.members__invite .input').val();
        appendMember(member);
        $('.invited__item').hide().closest(".invited").hide();
        if (! $('.invited__item').length == 0){
            var data = $.map($('.members__invite .invited__item .email'), function (el) {
                return $(el).text();
            });
            $.ajax({
                type: 'POST',
                url : '/api/v1/users/invite',
                data: {emails: data}
            }).success(function () {
                show_error('Приглашения отправлены', 3000);
                setTimeout(function () {
                    location.reload();
                }, 1500);
            }).error(function () {
                show_error('Произошла ошибка отправки', 3000);
            });
        }
    });
};

sendInvintationsInGroup = function () {
    $('.members__invite .js_inviteUserGroup').click(function () {
        var btn = $(this);
        if (! $('.invited__item').length == 0){
            var data = $.map($('.members__invite .invited__item .email'), function (el) {
                return $(el).text();
            });
            $.ajax({
                type: 'POST',
                url : '/api/v1/groups/' + btn.data("group_id") + '/invite',
                data: {emails: data}
            }).success(function () {
                show_error('Приглашения отправлены', 3000);
                setTimeout(function () {
                    location.reload();
                }, 1500);
            }).error(function () {
                show_error('Произошла ошибка отправки', 3000);
            });
        }
    });
};


deleteInvitedMember = function () {
    $('.members__in_system .members__in_system-item .js_removeUser').click(function () {
        var btn = $(this);
        confirm("Вы действительно хотите удалить пользователя?", function () {
            var number = btn.attr('data-id');
            $.ajax({
                type: 'POST',
                url : '/api/v1/users/remove_user',
                data: {id: number}
            }).success(function () {
                btn.closest('.members__in_system-item').remove();
                show_error('Пользователь удален', 3000);
            }).error(function () {
                show_error('Произошла ошибка', 3000);
            });
        });
    });
};

deleteMemberToGroup = function () {
    $('.members__in_system .members__in_system-item .js_removeUserToGroup').click(function () {
        var btn = $(this);
        var number = btn.data('id');
        var group_id = btn.data("group_id");
        btn.closest('.members__in_system-item').remove();
        $.ajax({
            type: 'POST',
            url : '/api/v1/groups/' + group_id + '/remove_user',
            data: {user_id: number}
        }).success(function () {
            show_error('Пользователь удален из группы', 3000);
        }).error(function () {
            show_error('Произошла ошибка', 3000);
        });
    });
};

searchMember = function () {
    $('.members__invite .input.searchMember').on('keyup paste input propertychange', function () {
        var input = $(this);
        var ul_users = $(".members.ingroups .members__in_system");
        var text_search = input.val();
        closeSearchMember(ul_users);
        if (text_search.length){
            var search_users_name = ul_users.find("li[data-name*='" + text_search + "']");
            var search_users_email = ul_users.find("li[data-email*='" + text_search + "']");
            if (search_users_name.length || search_users_email.length){
                ul_users.show();
                search_users_name.show();
                search_users_email.show();
            }
        }
    });
};
closeSearchMember = function (ul_users) {
    ul_users.hide();
    ul_users.find("li").hide();
};

addSearchMember = function () {
    $(".js_addSearchMember").click(function () {
        var member = $(this).data("email");
        var ul_users = $(".members.ingroups .members__in_system");
        closeSearchMember(ul_users);
        appendMember(member);
    });
};

$(document).ready(function () {
    invitedEmpty();
    invitedMemberDelete();
    inviteMember();

    sendInvintations();
    sendInvintationsInGroup();

    deleteInvitedMember();
    deleteMemberToGroup();

    searchMember();
    addSearchMember();

});
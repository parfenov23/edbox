$(document).ready(function () {
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

    inviteMember = function () {
        var emailRegexp = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
        $('.members__invite .input').focus(function () {
            $(window).keydown(function (e) {
                code = e.keyCode || e.which;
                if (code == 32){
                    e.preventDefault();
                    var member = $('.members__invite .input').val();
                    if (emailRegexp.test(member) == false){
                        if (member.length > 0){
                            show_error('Неправильный email', 3000);
                        }
                    }
                    else {
                        if ($(".invited__item div[data-email='" + member + "']").length == 0){
                            $('.members__invite .invited').show();
                            $('.members__invite .input').val('');
                            $('<li class="invited__item">' +
                                '<div class="email" data-email="' + member + '">' + member + '</div>' +
                                '<div class="cancel">×</div>' +
                            '</li>')
                                .appendTo('.members__invite .invited');
                        }else{
                            show_error('Email уже добавленн', 3000);
                            $('.members__invite .input').val('');
                        }
                    }
                }
            });
        });
    };

    sendInvintations = function () {
        $('.members__invite .plane').click(function () {
            if (! $('.invited__item').length == 0){
                var data = $.map($('.members__invite .invited__item .email'), function (el) {
                    return $(el).text();
                });
                $.ajax({
                    type: 'POST',
                    url : '/api/v1/users/invite',
                    data: {emails: data},
                }).success(function () {
                    show_error('Приглашения отправлены', 3000);
                    location.reload();
                }).error(function () {
                    show_error('Произошла ошибка отправки', 3000);
                });
            }
        });
    };

    deleteInvitedMember = function () {
        $('.members__in_system .members__in_system-item .delete').click(function () {
            var number = $(this).attr('data-id');
            $(this).closest('.members__in_system-item').remove();
            $.ajax({
                type: 'POST',
                url : '/api/v1/users/remove_user',
                data: {id: number},
            }).success(function () {
                show_error('Пользователь удален', 3000);
            }).error(function () {
                show_error('Произошла ошибка', 3000);
            });
        });
    };


    invitedEmpty();
    invitedMemberDelete();
    inviteMember();
    sendInvintations();
    deleteInvitedMember();

});
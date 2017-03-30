profileDataChange = function () {
    $('.profile__main #submit').click(function () {

        var data = $('.profile__main').serialize();
        $.ajax({
            type: 'POST',
            url : '/api/v1/users',
            data: data
        }).success(function () {
            $(".profile__main").addClass("close");
            show_error('Успешно сохранено', 3000);
        }).error(function () {
            show_error('Ошибка', 3000);
        });
    });
};

var passValid = function (btnClick) {
    var pass = $('#profile input[name=password]').val();
    var pass_repeat = $('#profile input[name=password_repeat]').val();
    var validate = false;
    $('#profile input[name=password], #profile input[name=password_repeat]').removeClass('error');
    if (pass === pass_repeat){
        $('#profile input[name=password_repeat]').removeClass('error');
        $('#profile input[name=password]').removeClass('error');
        validate = true;
    } else {
        validate = false;
        if (pass_repeat.length){
            $('#profile input[name=password_repeat]').addClass('error');
        } else {
            $('#profile input[name=password_repeat]').removeClass('error');
        }
    }
    if (btnClick == true){
        if (! pass_repeat.length){
            validate = false;
            $('#profile input[name=password_repeat]').addClass('error');
        }
        if (!pass.length){
            validate = false;
            $('#profile input[name=password]').addClass('error');
        }
    }
    return validate
};

profilePasswordChangeValidation = function () {
    $('#profile input').blur(function () {
        passValid();
    });
};

profilePasswordChange = function () {
    $('.profile__password #submit').click(function () {
        if (passValid(true)){
            var data = $('.profile__password input[name=password]').serialize();
            $.ajax({
                type: 'POST',
                url : '/api/v1/users/change_password',
                data: data
            }).success(function () {
                $('.profile__password').removeClass("open");
                show_error('Успешно сохранено', 3000);
            }).error(function () {
                show_error('Ошибка', 3000);
            });
        }else{
            show_error('Проверьте пароль', 3000);
        }

    });
};

$(document).ready(function () {
    profileDataChange();
    profilePasswordChangeValidation();
    profilePasswordChange();
    $(document).on('click', '.js_openEditPassword', function(){
        $(this).closest(".profile__password").addClass("open");
    });
    $(document).on('click', '.js_openChangeProfile', function(){
        $(this).closest(".profile__block").removeClass("close");
    });

    $("#profile input[name='user[social][phone]']").mask("+7 (999) 999-9999");
    var container = $(".profile__block input[name='user[city]']");
    container
    .kladr({
        type: $.kladr.type.city
    });
});
profileDataChange = function () {
    $('.profile__main #submit').click(function () {
        var data = $('.profile__main').serialize();
        $.ajax({
            type: 'POST',
            url : '/api/v1/users',
            data: data
        }).success(function () {
            console.log('111');
            show_error('Успешно сохранено', 3000);
        }).error(function () {
            console.log('111');
            show_error('Ошибка', 3000);
        });
    });
};

profilePasswordChangeValidation = function () {
    $('#profile input').blur(function () {
        var pass = $('#profile input[name=password]').val();
        var pass_repeat = $('#profile input[name=password_repeat]').val();
        if (pass === pass_repeat){
            $('#profile input[name=password_repeat]').removeClass('error');
        } else {
            if (pass_repeat.length){
                $('#profile input[name=password_repeat]').addClass('error');
            }else{
                $('#profile input[name=password_repeat]').removeClass('error');
            }
        }
    });
};

profilePasswordChange = function () {
    $('.profile__password #submit').click(function () {
        var data = $('.profile__password input[name=password]').serialize();
        $.ajax({
            type: 'POST',
            url : '/api/v1/users/change_password',
            data: data
        }).success(function () {
            show_error('Успешно сохранено', 3000);
        }).error(function () {
            show_error('Ошибка', 3000);
        });
    });
};

$(document).ready(function(){
    $("img:last").load(function(){
        profileDataChange();
        profilePasswordChangeValidation();
        profilePasswordChange();
    })
});
var actionEndInclude = function () {};

var checkValidPhoneCode = function () {
    var block = $(".popValidateCodePhone");
    var input_code = block.find('input[type="text"]').val();
    var valid_code = block.find('input.idValuePhoneCode').val();
    if (input_code == valid_code){
        show_error('Успешно', 3000);
        $('.form-control[type="tel"]').attr('data-valid', 'true');

        block.css('display', 'none');
        //window.location.href = '/courses';
        setTimeout(actionEndInclude, 1500);
    } else {
        show_error('Вы ввели неправильный проверочный код', 3000);
    }
};

var include_phone = function (input, action) {
    if (action != undefined){
        actionEndInclude = action;
    }
    if (input.val().length){
        var code = getRandomInt(1000, 9999);
        $.ajax({
            type: 'POST',
            url : '/api/v1/users/include_phone',
            data: {phone: input.val(), code: code}
        }).success(function () {
            var block = $(".popValidateCodePhone");
            block.css('display', 'flex');
            block.find('.idValuePhoneCode').val(code);
        }).error(function () {
            show_error('Ошибка', 3000);
        });
    }
};

pageLoad(function () {
    $(document).on('click', '.js__checkValidPhoneCode', checkValidPhoneCode);
});
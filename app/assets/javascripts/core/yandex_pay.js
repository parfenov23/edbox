var subscription_pay = function (type, email, data) {
    if (data == undefined) data = {type_account: type, email: email};
    $.ajax({
        type: 'POST',
        url : '/subscription/pay',
        data: data
    }).success(function (data) {
        var form = $(data);
        form.submit();
    });
};

pageLoad(function () {
    var input_notify = $("input#notifyPayMessage");
    if (input_notify.length){
        if (input_notify.val() == "success") warning('Оплата успешно прошла.', 'Хорошо');
        if (input_notify.val() == "fail") warning('При оплате произошла ошибка, попробуйте еще раз.', 'Хорошо');
        if (input_notify.val() == "fail_money") warning('При оплате произошла ошибка, недостаточно средств на счете. Попробуйте еще раз.', 'Хорошо');

    }
});
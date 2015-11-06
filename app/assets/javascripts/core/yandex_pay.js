var subscription_pay = function (type, email, data) {
    if (data == undefined) data = {type_account: type, email: email}
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
        if (input_notify.val() == "success") warning('Заявка успешно отправлена, скоро вы получите письмо с доступами в Edbox.', 'Хорошо');
        if (input_notify.val() == "fail") warning('При оформлении зайвки произошли проблемы, попробуйте еще раз.', 'Хорошо');
    }
});
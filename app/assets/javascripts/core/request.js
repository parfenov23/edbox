var validate_request = function () {
    $.each($('form.formRequest input'), function (k, el) {
        var block = $(el);
        var parent_block = block.closest(".item");

        if (! block.val()){
            parent_block.addClass('error');
        } else {
            parent_block.removeClass('error');
        }

        if (block.attr("name") == "email"){
            if (validateEmail(block.val())){
                parent_block.removeClass('error');
            } else {
                parent_block.addClass('error');
            }
        }

        if (block.attr("name") == "fio"){
            if (block.closest(".form__col").find("input[name='type_account']").val() == "user"){
                parent_block.removeClass("error");
            }
        }
        if (block.attr("name") == "company"){
            if (block.closest(".form__col").find("input[name='type_account']").val() == "user"){
                parent_block.removeClass("error");
            }
        }
    });
};

var validate_offer = function (form) {
    var bigform = form.closest('.item');
    var offerCheckbox = bigform.find('.js_offerCheckbox')
    if (offerCheckbox.attr("checked")){
        return true;
    }
    show_error('Вы должны согласиться с договором оферты', 3000)
    return false;
};

var sendRequestForm = function(){
    var btn = $(this);
    var form = btn.closest(".form__SendMessage").find(".formRequest");
    form.addClass("attempt");
    var offer = validate_offer(form);

    validate_request();
    var error_inputs = form.find(".item.error");
    if ((!error_inputs.length) && (validate_offer(form))){
        $.ajax({
            type: 'POST',
            url : '/api/v1/users/send_request',
            data: form.serialize()
        }).success(function () {
            btn.closest(".ugly__popup").hide();
            //warning('Заявка успешно отправлена, скоро вы получите письмо с доступами в Edbox', 'Хорошо');
            //pay_redirect(form);
            var item = form.closest(".item");
            var type_account = item.find("input[name='type_account']").val();
            var email = form.find("input[name='email']").val();
            if (type_account == "user"){
                subscription_pay(type_account, email);
            }else{
                warning('Заявка успешно отправлена, скоро вы получите письмо с доступами в Edbox', 'Хорошо');
            }
        }).error(function () {
            show_error('Ошибка', 3000);
        });
    }
};

var change_formRequest_Input = function(){
    if($("form.formRequest").hasClass('attempt')){
        validate_request();
    }
};

pageLoad(function () {
    $(document).on('click', '.js_sendRequestForm', sendRequestForm);
    $('form.formRequest input').change(change_formRequest_Input)
});

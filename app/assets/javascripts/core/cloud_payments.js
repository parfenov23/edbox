var openInfoProgress = function (type) {
    if (type != "close"){
        $("#paymentsPopup .infoProgress").show();
        $("#paymentsPopup  form#paymentFormSample").hide();
    } else {
        $("#paymentsPopup .infoProgress").hide();
    }
};

var includePaymentMethods = function () {
    createCryptogram = function () {
        if (! validate_company_form()) return false;
        openInfoProgress();
        var user_name = form().find("input[data-cp='name']").val();
        var card_number = form().find("input[data-cp='cardNumber']").val();
        var result = checkout.createCryptogramPacket();
        if (result.success){
            var cryptogram = result.packet;
            $.ajax({
                type: 'POST',
                url : '/api/v1/payments/update_card',
                data: {cryptogram: cryptogram, name: user_name, card: card_number}
            }).success(function (data) {
                pageReloadPayment();
            }).error(function (data) {
                var data_json = data.responseJSON;
                if (data_json.type == '3ds'){
                    updateForm3ds(data_json.response);
                } else {
                    show_error('Ошибка', 3000);
                }
            });
        } else {
            openInfoProgress('close');
            $("#paymentFormSample").show();
            show_error('В введенных вами данных допущена ошибка', 3000);
        }
    };

    $(function () {
        /* Создание checkout */
        checkout = new cp.Checkout(
            // public id из личного кабинета
            form().data("public_id"),
            // тег, содержащий поля данными карты
            document.getElementById("paymentFormSample"));
    });
};

var pageReloadPayment = function () {
    $("#3ds").hide();
    form().show();
    $("#paymentsPopup").removeClass("h__PopupDisplayFlex");
    if (form().data('reload')){
        show_error('Карта успешно сохранена', 3000);
        setTimeout(function () {
            window.location.reload();
        }, 1500);
    } else {
        //var btn = $("form.tariffPay .action__block .btn.js_openPopupAddCard");
        //btn.removeClass('js_openPopupAddCard').addClass('js_paymentAccount');
        paymentAccount();
    }
};

var paymentAccount = function (type) {
    var valid = form().data('payment');
    if (type == "btn") valid = true;
    if (valid){
        var sum = $(".parentPriceTariff .qty span").text();
        confirm("Вы уверены что хотите оплатить подписку? C вашего счета будет списано " + sum + " ₽", function () {
            purchase_pay();
        });
    }
};

var purchase_pay = function () {
    var form = $("form.tariffPay");
    var data = form.serializeArray();
    data.push({name: 'phone', value: $('input[type="tel"]').val()});
    show_error('Идет Загрузка ', 3000);
    $.ajax({
        type: 'POST',
        url : '/api/v1/payments/purchase',
        data: $.param(data)
    }).success(function (data) {
        if (data.success){
            show_error('Оплата успешно прошла', 3000);
            var endAction = function(){
                window.location.href = '/courses';
            };
            if($('.form-control[type="tel"]').attr('data-valid') != 'true' ){
                include_phone($('.form-control[type="tel"]'), endAction);
            }else{
                setTimeout(endAction, 1500);
            }

        } else {
            show_error('Произошла ошибка', 3000);
        }
    });
};

var updateForm3ds = function (json) {
    $("form#paymentFormSample").hide();
    var form = $("form#secure_card");
    form.find("[name='PaReq']").val(json.PaReq);
    form.find("[name='MD']").val(json.TransactionId);
    form.attr("action", json.AcsUrl);
    form.submit();
    openInfoProgress('close');
    form.closest("#3ds").show();
};

var removePaymentCard = function () {
    var btn = $(this);
    $.ajax({
        type: 'POST',
        url : '/api/v1/payments/remove_card'
    }).success(function () {
        show_error('Карта успешно удаленна', 3000);
        setTimeout(function () {
            window.location.reload();
        }, 1500);
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

var openPopupAddCard = function () {
    if (! validate_company_form()) return false;
    $("#paymentsPopup").addClass("h__PopupDisplayFlex");
};

var includeTypeCard = function () {
    var input = $("[data-cp='cardNumber']");
    var block_logo = $('#paymentFormSample .cardLogo');
    block_logo.removeClass('fa-cc-visa fa-cc-mastercard');
    if (input.val().substring(0, 1) == 4){
        block_logo.addClass('fa-cc-visa');
    }

    if (input.val().substring(0, 2) == 51 ||
        input.val().substring(0, 2) == 52 ||
        input.val().substring(0, 2) == 53 ||
        input.val().substring(0, 2) == 54 ||
        input.val().substring(0, 2) == 55){
        block_logo.addClass('fa-cc-mastercard');
    }
};

pageLoad(function () {
    if ($("#paymentFormSample").length){
        includePaymentMethods();
        $("input[data-cp='cardNumber']").mask("9999 9999 9999 9999", {completed: includeTypeCard});
        $("input[data-cp='expDateMonthYear']").mask("99/99", {placeholder: "ММ/ГГ"});
        $("#paymentFormSample [data-cp='cardNumber']").change(includeTypeCard);

        $(document).on('click', '#paymentFormSample .addCart', createCryptogram);
        $(document).on('click', '.js_removePaymentCard', removePaymentCard);
        $(document).on('click', '.js_openPopupAddCard', openPopupAddCard);
    }
});

var form = function () {
    return $("#paymentFormSample");
};

window.showMessage = function (result) {
    if (result.success){
        var status = result.response.json.type;
        if (status == 'success'){
            pageReloadPayment();
            setTimeout(function () {
                paymentAccount();
            }, 1000);

        }
    } else {
        $("#3ds").hide();
        $("#paymentFormSample").show();
        $("#paymentsPopup").removeClass('h__PopupDisplayFlex');
        show_error('Произошла ошибка', 3000);
    }
};

var orderBill = function () {
    if (validate_company_form()){
        var form = $(this).closest("form").serialize();
        $.ajax({
            type: 'POST',
            url : '/api/v1/payments/order_bill',
            data: form
        }).success(function () {
            //show_error('Заявка отправленна', 3000);
            //setTimeout(function () {
            //    window.location.href = '/'
            //}, 1500);

            warning('Спасибо! Ваша заявка получена. В ближайшее время сотрудник ADCONSULT Online свяжется с вами.', 'Продолжить',
                function () {
                    window.location.href = '/'
                })
        }).error(function () {
            show_error('Произошла ошибка', 3000);
        });
    }
};

var validate_company_form = function () {
    var result = true;
    if ($(".company__name").length){
        $(".com__input-item").removeClass("error");
        $(".company__name input").not('input[name="code_coupon"]').each(function (i, e) {
            if (! $(e).val().length){
                result = false;
                $(e).closest(".com__input-item").addClass("error");
            }
        });
        //if ($('.form-control[type="tel"]').attr('data-valid') == "false"){
        //    result = false;
        //}
    }
    return result;
};



var change_mask_phone = function(code){
    if(code == undefined) code = '+7 (999) 999-99-99';
    $(".company__name input[name='company_phone'], .user_phone input[name='user[social][phone]']").mask(code);
};
pageLoad(function () {
    $('.company__name input[name="code_coupon"]').change(function(){
        var code = $(this).val();
        findCoupon(code, function(data){
            var form = $('form .qty');
            var sum = data.price;
            form.find("input[name='sum']").val(sum);
            form.find("span").text(sum);
            $(this).closest('.com__input-item').remove();
        });
    });

    $(document).on('click', '.js_paymentAccount', function () {
        paymentAccount('btn');
    });

    if ($(".company__name input[name='company_phone'], .user_phone input[name='user[social][phone]']").length){
        change_mask_phone();
    }

    $(document).on('click', ".company__name input[name='company_phone']", function () {
        var btn = $(this);
        btn.closest(".com__input-item").removeClass('empty');
    });

    $('.company__name #code_code_id, .user_phone #code_code_id').change(function(){
        var code = $(this).val();
        change_mask_phone(code);
    });

    $(document).on('click', '.js_orderBill', orderBill);

    //$('.form-control[type="tel"]').change(include_phone);

});
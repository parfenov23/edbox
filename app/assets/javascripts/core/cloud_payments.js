var includePaymentMethods = function () {
    createCryptogram = function () {
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
        var btn = $("form.tariffPay .action__block .btn.js_openPopupAddCard");
        btn.removeClass('js_openPopupAddCard').addClass('js_paymentAccount');
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
    $.ajax({
        type: 'POST',
        url : '/api/v1/payments/purchase',
        data: form.serialize()
    }).success(function (data) {
        if (data.success){
            show_error('Оплата успешно прошла', 3000);
            setTimeout(function () {
                window.location.href='/profile';
            }, 1500);
        }else{
            show_error('Произошла ошибка', 3000);
        }
    });
};

var updateForm3ds = function (json) {
    var form = $("form#secure_card");
    form.find("[name='PaReq']").val(json.PaReq);
    form.find("[name='MD']").val(json.TransactionId);
    form.attr("action", json.AcsUrl);
    form.submit();
    $("form#paymentFormSample").hide();
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
    $("#paymentsPopup").addClass("h__PopupDisplayFlex");
};

pageLoad(function () {
    if ($("#paymentFormSample").length){
        includePaymentMethods();

        $("#paymentFormSample [data-cp='cardNumber']").change(function () {
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
        });

        $(document).on('click', '#paymentFormSample .addCart', createCryptogram);
        $(document).on('click', '.js_removePaymentCard', removePaymentCard);
        $(document).on('click', '.js_openPopupAddCard', openPopupAddCard);
    }
});

var form = function () {
    return $("#paymentFormSample");
};

window.showMessage = function (result) {
    var status = result.response.json.type;
    if (status == 'success'){
        pageReloadPayment();
        setTimeout(function () {
            paymentAccount();
        }, 1000);

    }
};

pageLoad(function () {
    $(document).on('click', '.js_paymentAccount', function(){
        paymentAccount('btn');
    });
});
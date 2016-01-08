var editPriceMonthTariff = function () {
    var btn = $(this);
    var parent_block = btn.closest(".parentPriceTariff");
    var price_block = parent_block.find(".sum .qty span");
    price_block.text(btn.data('price'));
    parent_block.find("input[name='sum']").val(btn.data('price'));
    btn.closest("ul").hide();
    parent_block.find(".duration .visible__part span").text(btn.text());
    parent_block.find("input[name='count_month']").val(btn.text());
    btn.closest("ul").find('li.active').removeClass('active');
    btn.addClass('active');
    if ($(".js_editChangeCountUsersCompany").length){
        addUserSumToPrice($(".js_editChangeCountUsersCompany"));
    }
    replaceSumTitle();
};

var addUserSumToPrice = function (input) {
    var parent_block = input.closest(".parentPriceTariff");
    var price_block = parent_block.find(".sum .qty span");
    var current_price = 0;
    var def_cUsers = parseInt(input.data('default'));
    var intVal = parseInt(input.val());
    var oneUserPrice = parseInt(parent_block.data('user_price'));
    var user_price = oneUserPrice * (intVal - def_cUsers);

    var priceActive = $(".js_editPriceMonthTariff li.active")

    if (priceActive.length){
        current_price = parseInt(priceActive.data('price'));
    }

    if (def_cUsers < intVal){
        var final_price = current_price + user_price;
        price_block.text(final_price);
        parent_block.find("input[name='sum']").val(final_price);
    } else {
        if (!priceActive.length){
            price_block.text(0);
            parent_block.find("input[name='sum']").val(0);
        }else{
            price_block.text(current_price);
            parent_block.find("input[name='sum']").val(current_price);
        }
    }
    replaceSumTitle();
};

var replaceSumTitle = function () {
    var priceTitle = $(".parentPriceTariff .sum .qty span");
    if (priceTitle.length){
        priceTitle.text(priceTitle.text().replace(/(\d)(?=(\d\d\d)+([^\d]|$))/g, '$1 '))
    }
};

var submitFormEditTariff = function () {
    var form = $(this).closest(".content__block").find("form");
    //var data = form.serialize();
    form.submit();
    //console.log(data);
    //subscription_pay('', '', data);
};

pageLoad(function () {
    $(document).on('click', '.js_editPriceMonthTariff li', editPriceMonthTariff);
    $(document).on('click', '.js_submitFormEditTariff', submitFormEditTariff);
    $('.js_editChangeCountUsersCompany').change(function () {
        addUserSumToPrice($(this));
    });
    var inpCuser = $('.js_editChangeCountUsersCompany')
    if (inpCuser.length && (inpCuser.val() == inpCuser.data('default') || inpCuser.val() == "1")){
        $('.js__stuf_count').addClass('is__empty')
    }
    replaceSumTitle();
});
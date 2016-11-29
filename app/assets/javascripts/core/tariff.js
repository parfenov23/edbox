var editPriceMonthTariff = function () {
    var btn = $(this);
    var parent_block = btn.closest(".parentPriceTariff");
    var price_block = parent_block.find(".sum .qty span");
    price_block.text(btn.data('price'));
    parent_block.find("input[name='sum']").val(btn.data('price'));

    ///////////////////////
    btn.closest("ul").hide();
    parent_block.find(".duration .visible__part span").text(btn.text());
    parent_block.find("input[name='count_month']").val(btn.text());
    btn.closest("ul").find('li.active').removeClass('active');
    //////////////////////

    btn.addClass('active');
    if ($(".js_editChangeCountUsersCompany").length){
        addUserSumToPrice($(".js_editChangeCountUsersCompany"));
    }
    replaceSumTitle();
};

var addUserSumToPrice = function (input) {
    var parent_block = input.closest(".parentPriceTariff");
    var price_block = parent_block.find(".sum .qty span"); // вывод конечной цены
    var form_price = parent_block.find("input[name='sum']"); // цена на оплату

    var intVal = parseInt(input.val()); // Текущие количество пользователей
    var def_cUsers = parseInt(input.data('default')); // Количество оплаченых пользователей
    var oneUserPrice = parseInt(parent_block.data('user_price'));
    var day_of_month = parseInt(parent_block.data("day_of_month"));
    var residue_of_month = parseInt(parent_block.data("residue_of_month"));

    var residue_price_user = (oneUserPrice/day_of_month)*residue_of_month;
    var new_users = intVal - def_cUsers;

    var finish_price = Math.round((new_users * (residue_price_user || 0) ) + ((new_users + def_cUsers) * oneUserPrice));

    price_block.text(finish_price);
    form_price.val(finish_price);

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
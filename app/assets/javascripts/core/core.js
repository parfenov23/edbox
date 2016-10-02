function clearFileInputField(id) {
    var el = $("#" + id);
    var el_html = el.prop('outerHTML');
    var el_parent = el.parent();
    el.remove();
    el_parent.append($(el_html));
}

var view_px_block = function (block) {
    var win_height = $(window).height();
    var curr_pos = block.position().top;
    var curr_scroll = $(document.body).scrollTop();
    var accessing_top = parseInt(block.css("margin-top")) + parseInt(block.css("padding-top"));

    var do_block = win_height + curr_scroll - (curr_pos + 64 + accessing_top);
    return do_block
};

var rightFilterShowSubsidiary = function () {
    var btn = $(this);
    var block = btn.closest(".parent_tag").find("ul:first");
    if (block.is(":visible")){
        btn.closest(".parent_tag").removeClass("open");
        block.hide();
    } else {
        btn.closest(".parent_tag").addClass("open");
        block.show();
    }

};

var searchFilterTagFind = function () {
    var btn = $(this);
    window.location.href = '/courses?tid=' + btn.data('id');
};

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min)) + min;
}

var findCoupon = function (coupon, callback) {
    $.ajax({
        type: 'POST',
        url : '/api/v1/payments/find_coupon',
        data: {coupon: coupon}
    }).success(function (data) {
        if (data != null){
            callback(data);
        }
    }).error(function () {
        show_error('Ошибка', 3000);
    });
};

var current_user = function(){
    return $("#presentCurrentUser").val() == "true"
};

var CurrentUserUpdatePhone = function(phone){
    $.ajax({
        type: 'POST',
        url : '/api/v1/users/update_phone',
        data: {phone: phone}
    });
};

pageLoad(function () {
    var back_item_link = $("a.item[href='backCourse']");
    if (back_item_link.length){
        back_item_link.attr('href', back_url('find', ["courses", 'cabinet']))

    }
    $(document).on('click', '#js-filter-courses .parentTreeUl .parent_tag .title', rightFilterShowSubsidiary);
    $(document).on('click', '.last_subtag .js__searchFilterTagFind', searchFilterTagFind);

    $('embed').mousedown(function (event) {
        event.preventDefault();
        if (event.button == 0){
            console.log('disable');
        } else if (event.button == 1){
            console.log('disable');
        } else if (event.button == 2){
            console.log('disable');
        }
    });
});


// include valid phone

var actionEndInclude = function () {};

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

pageLoad(function () {
    $(document).on('click', '.js__checkValidPhoneCode', checkValidPhoneCode);
});
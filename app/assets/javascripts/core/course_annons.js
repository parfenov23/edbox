var annons = function(){
    var popup = $("#notify_me");
    popup.toggleClass('is__active');
};

var annonsNext = function(){
    var popup = $("#notify_next");
    popup.toggleClass('is__active');
};

var annonsReg = function(){
    var btn = $(this);
    var email = btn.data('email');
    var course_id = btn.data('course_id');
    $.ajax({
        type       : 'POST',
        url        : '/api/v1/notices',
        data       : {
            notice: {
                "email" : email,
                "course_id" : course_id
            }
        }
    }).success(function () {
    }).error(function () {
        show_error('Ошибка', 3000);
    });
    var popup = $("#notify");
    popup.toggleClass('is__active');
};


var annonsSend = function(){
    var btn = $(this);
    if (!(btn.hasClass('disable'))) {
        var form = $(btn).closest('form');
        var data = form.serialize();
        $.ajax({
            type       : 'POST',
            url        : '/api/v1/notices',
            data       : data
        }).success(function () {
            annons();
            annonsNext();
        }).error(function () {
            show_error('Ошибка', 3000);
        });
    }
};

var setTimeoutAnnonsEmail;
var annonsEmail = function(){
    var block = $(this);
    var popup =  $(block).closest('.pop_up_confirm');
    var btn = $(popup).find('.js_annonsSend');
    clearTimeout(setTimeoutAnnonsEmail);
    setTimeoutAnnonsEmail = setTimeout(function () {
        if(validateEmail(block.val())){
            block.removeClass('error');
            btn.removeClass('disable');
        }else{
            block.addClass('error');
            btn.addClass('disable');
        }
    }, 150);
};

pageLoad(function(){
    $(document).on('click', '.js_annons', annons);
    $(document).on('click', '.js_annonsReg', annonsReg);
    $(document).on('click', '.js_annonsSend', annonsSend);
    $(document).on('click', '.js_annonsNext', annonsNext);
    $(document).on('keyup paste input propertychange', 'input.js_annonsEmail', annonsEmail);
});
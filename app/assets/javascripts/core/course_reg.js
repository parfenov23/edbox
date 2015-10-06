var openFormRegistration = function(){
    var popup = $("#formCourseRegPopUp");
    popup.show();
    $(document).scrollTop( popup.offset().top);
};

var regFromLanding = function(regtype){
    if ($('.js_openFormRegistration').length != 0){
        $.when(openFormRegistration()).then(function () {
            if (regtype.data('type') == 'pers'){
                $("#formCourseRegPopUp .pidor__raz .btn").click();
            }
            if (regtype.data('type') == 'corp'){
                $("#formCourseRegPopUp .pidor__dva .btn").first().click();
            }
        });
    };
};

pageLoad(function(){
    $(document).on('click', '.js_openFormRegistration', openFormRegistration);
    if ($('.js_regFromLanding').length != 0) {
        regFromLanding($('.js_regFromLanding'));
    }
});
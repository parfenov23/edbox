var openFormRegistration = function(){
    //var btn = $(this);
    //var popup = $("#formCourseRegPopUp");
    //popup.show();
    //$(document).scrollTop( popup.offset().top);
    //if($(this).hasClass("selectType")){
    //    selectType(btn.data('type'));
    //}
    window.location.href='/sign_up'
};

var selectType = function(type){
    if (type == 'pers'){
        $("#formCourseRegPopUp .pidor__raz .btn.pers").click();
    }
    if (type == 'corp'){
        $("#formCourseRegPopUp .pidor__dva .btn.corp").click();
    }
};

var openFormRegistrationAuth = function(){
    var btn= $(this);
    if(btn.data('type') == "free") {
        window.location.href = back_url('find', ['/courses', "/course_description", "/attachment"], '/cabinet');
    }else{
        window.location.href = '/payment?type=' + btn.data('type') + "&page=reg";
    }
    //window.location.href = '/sign_up';
    //var popup = $("#openFormRegistrationAuth");
    //popup.show();
    //$(document).scrollTop( popup.offset().top);
};

var regFromLanding = function(regtype){
    if ($('.js_openFormRegistration').length != 0){
        $.when(openFormRegistration()).then(function () {
            selectType(regtype.data('type'));
        });
    };
};

pageLoad(function(){
    $(document).on('click', '.js_openFormRegistration', openFormRegistration);
    $(document).on('click', '.js_openFormRegistrationAuth', openFormRegistrationAuth);
    if ($('.js_regFromLanding').length != 0) {
        regFromLanding($('.js_regFromLanding'));
    }

});
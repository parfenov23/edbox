var openFormRegistration = function(){
    var btn = $(this);
    $("#formCourseRegPopUp").show();
    $(document).scrollTop(0);
    var val_inp = $("input[name='company[name]']");
    var selected = $(".js_registrationUser .auth__reg-selected");
    var input_corp_name = $(".js_registrationUser .input-wrp.corporate_acc");
    if (btn.data('type') == 'corp'){
        selected.text("Корпоративный аккаунт");
        input_corp_name.addClass("active");
    }else{
        input_corp_name.removeClass("active");
        selected.text("Персональный аккаунт");
    }
};

pageLoad(function(){
    $(document).on('click', '.not__auth-block .js_openFormRegistration', openFormRegistration);
});
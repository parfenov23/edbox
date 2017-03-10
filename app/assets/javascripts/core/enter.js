function validateEmail($email) {
    var emailReg = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    return emailReg.test($email);
}

function checkPassword(password) {
    var s_letters = "qwertyuiopasdfghjklzxcvbnm"; // Буквы в нижнем регистре
    var b_letters = "QWERTYUIOPLKJHGFDSAZXCVBNM"; // Буквы в верхнем регистре
    var digits = "0123456789"; // Цифры
    var specials = "!@#$%^&*()_-+=\|/.,:;[]{}"; // Спецсимволы
    var is_s = false; // Есть ли в пароле буквы в нижнем регистре
    var is_b = false; // Есть ли в пароле буквы в верхнем регистре
    var is_d = false; // Есть ли в пароле цифры
    var is_sp = false; // Есть ли в пароле спецсимволы
    for (var i = 0; i < password.length; i ++){
        /* Проверяем каждый символ пароля на принадлежность к тому или иному типу */
        if (! is_s && s_letters.indexOf(password[i]) != - 1) is_s = true;
        else if (! is_b && b_letters.indexOf(password[i]) != - 1) is_b = true;
        else if (! is_d && digits.indexOf(password[i]) != - 1) is_d = true;
        else if (! is_sp && specials.indexOf(password[i]) != - 1) is_sp = true;
    }
    var rating = 0;
    var text = "";
    var klass = "";
    if (is_s) rating ++; // Если в пароле есть символы в нижнем регистре, то увеличиваем рейтинг сложности
    if (is_b) rating ++; // Если в пароле есть символы в верхнем регистре, то увеличиваем рейтинг сложности
    if (is_d) rating ++; // Если в пароле есть цифры, то увеличиваем рейтинг сложности
    if (is_sp) rating ++; // Если в пароле есть спецсимволы, то увеличиваем рейтинг сложности
    /* Далее идёт анализ длины пароля и полученного рейтинга, и на основании этого готовится текстовое описание сложности пароля */
    if (password.length < 6 && rating < 3 && password.length >= 4) klass = "lvl-2", text = "Простой";
    else if (password.length < 4 && rating < 3) klass = "lvl-1", text = "Очень простой";
    else if (password.length < 6 && rating >= 3) klass = "lvl-3", text = "Хороший";
    else if (password.length >= 8 && rating < 3) klass = "lvl-3", text = "Хороший";
    else if (password.length >= 8 && rating >= 3) klass = "lvl-4", text = "Сложный";
    else if (password.length >= 6 && rating == 1) klass = "lvl-2", text = "Хороший";
    else if (password.length >= 6 && rating > 1 && rating < 4) klass = "lvl-3", text = "Хороший";
    else if (password.length >= 6 && rating == 4) klass = "lvl-4", text = "Сложный";
    return [klass, text]; // Форму не отправляем
}

function view_px_block(block) {
    var win_height = $(window).height();
    var curr_pos = block.position().top;
    var curr_scroll = $(document.body).scrollTop();
    var accessing_top = parseInt(block.css("margin-top")) + parseInt(block.css("padding-top"));

    var do_block = win_height + curr_scroll - (curr_pos + 64 + accessing_top);
    return do_block
}

/* Сабмит профиля */
function fixed_btn_save() {
    var block = $(".oferta_holder .auth_oferta");
    var block_action = block.find(".btn_active_fixed:visible");
    if (block.length > 0 && block_action.length > 0){
        var do_block = view_px_block(block);
        var block_height = parseInt(block.innerHeight());
        var block_action_height = parseInt(block_action.outerHeight());
        var header_height = 0;
        var view_action_top = do_block - header_height;
        var block_action_normal = function () {
            block.css("height", "");
            block_action.css("position", "").css("top", "")
                .css("bottom", "")
                .removeClass("fixed_bot")
                .removeClass("absolute_top")
                .css("z-index", "")
                .css("width", "");

        };

        var block_action_position_top = function () {
            block_action.css("position", "relative");
            block_height = block.outerHeight();
            block_action
                .css("top", ((0 - (block_height - block_action_height) ) + header_height) + "px")
                .css("bottom", "")
                .css("z-index", "10")
                .css("width", block.outerWidth())
        };

        var block_action_position_fixed = function () {
            block.css("height", block_height + "px");
            block_action.css("position", "fixed")
                .css("top", "")
                .css("bottom", "0px")
                .css("z-index", "10")
                .css("margin-left", "-24px")
                .css("width", block.outerWidth())
        };

        if (view_action_top + 5 >= 0 && (view_action_top - block_action_height) <= 0){
            block_action_position_top();
        }

        if ((view_action_top - block_action_height) >= 0 && (view_action_top + block_action_height) <= block_height + 20){
            block_action_position_fixed();
        }

        if (do_block + 105 >= (block_height )){
            block_action_normal();
        }

    }
}
// сброс пароля
var resetPassword = function () {
    var data = $(this).closest("form").serialize();
    $.ajax({
        type   : 'POST',
        url    : '/api/v1/sessions/recover_password',
        data   : data,
        success: function (data) {
            show_error('Вам на почту выслан новый пароль', 3000);
            setTimeout(function () {
                window.location.href = '/sign_in'
            }, 1000)
        },
        error  : function () {
            show_error('Пользователя с таким Email не существует', 3000);
        }
    });
};
/////////////

function reg_the_social(params) {
    var data = params;
    var form = $(".js_registrationUser #submit").closest('form');
    $.ajax({
        type   : 'POST',
        url    : '/api/v1/sessions/registration',
        data   : {user: data},
        success: function (m) {
            fbq_env('CompleteRegistration');
            $.cookie('user_key', m.user_key);
            if (form.data('redirect') == undefined){
                $("#formCourseRegPopUp").show();
            } else {
                window.location.href = form.data('redirect');
            }

        },
        error  : function (m) {

            show_error(m.responseJSON.error, 3000);
        }
    });
};


function getTokenGplusAuth(data_g) {
    $.ajax({
        type   : 'POST',
        url    : 'https://www.googleapis.com/oauth2/v4/token',
        data   : data_g,
        success: function (m) {
            window.location.href = '/sign_up?type=gplus&access_token=' + m.access_token;
        }
    });
};

var validRegClickOfert = function () {
    var btn = $(this);
    var valid_error = false;
    $('input.checkbox, .form-control[type="tel"], .com__input-item.user_phone').removeClass('error');
    if (! btn.closest('form').find(".auth_agree.checkbox__holder input.checkbox").is(':checked')){
        $('input.checkbox').addClass('error');
        valid_error = true;
    }
    if (! $('.form-control[type="tel"]').val().length){
        $('.form-control[type="tel"], .com__input-item.user_phone').addClass('error');
        valid_error = true;
    } else {
        $.cookie('user_phone', $('.form-control[type="tel"]').val());
    }

    if (valid_error){
        show_error("Пожалуйста, заполните обязательные поля", 3000);
    } else {
        var curr_href = $(this).attr('href');
        var endAction = function () {
            window.location.href = curr_href
        };
        include_phone($('.form-control[type="tel"]'), endAction);
    }
    return false;
};

$(document).ready(function () {
    $(document).on('click', ".js_registrationUser [name='user[social][phone]']", function(){
        $(this).closest(".com__input-item").removeClass("empty");
    });

    $(document).on('keyup paste input propertychange', '.js_registrationUser input[name="user[password]"]', function () {
        var valPass = checkPassword($(this).val());
        $(this).closest(".com__input-item").removeClass("error lvl-1 lvl-2 lvl-3 lvl-4").addClass("error " + valPass[0]);
        $(this).closest(".com__input-item").find(".error__msg").text(valPass[1]);
    });

    $(".js_LendingGoToSubscription").on('click', function () {
        $('html,body').animate({
            scrollTop: $("#divToBeScrolledTo").offset().top - 64
        });
    });

    $(document).on('click', '.js_FormAuthResetPass .js_resetPassword', resetPassword);
    $(document).on('click', '#js_validRegClickOfert', validRegClickOfert);
    $(document).on('click', '.jsOpenLandingCompareTable', function () {
        $(this).closest(".popupRequestRegistration").find("section.landing__compare__table").show();
        $(this).closest(".showInfo").hide();
    });

    if ($("form.js_registrationUser").length){
        (function () {
            $('.phoenix-input').phoenix();

            $('[data-phoenix-action]').on('click', function (e) {
                $('.phoenix-input').phoenix($(this).data('phoenix-action'));
                e.preventDefault();
                return e.stopPropagation();
            });

        }).call(this);
        var val_inp = $("input[name='company[name]']");
        var selected = $(".js_registrationUser .auth__reg-selected");
        var input_corp_name = $(".js_registrationUser .input-wrp.corporate_acc");
        var param_type = $("#paramsInputTypeAccount").val();
        if (param_type != undefined && ! param_type.length){
            if (val_inp.count_text_input()){
                selected.text("Корпоративный аккаунт");
                input_corp_name.addClass("active");
            } else {
                input_corp_name.removeClass("active");
                selected.text("Персональный аккаунт");
            }
        }

        $.each($(".phoenix-input"), function (n, e) {
            if ($(e).count_text_input()) $(e).closest(".com__input-item").removeClass("empty").addClass("is__noFocus");
        })

    }

    $(window).scroll(function () {
        fixed_btn_save();
    });
    $(window).resize(function () {
        fixed_btn_save();
    });
    fixed_btn_save();
    $(".js_FormAuth #submit").click(function (e) {
        e.preventDefault();
        var btn = $(this);
        var form = btn.closest("form");
        var data = form.serialize();
        show_error('Идет проверка данных', 3000);
        $.ajax({
            type   : 'POST',
            url    : '/api/v1/sessions/auth',
            data   : data,
            success: function (user) {
                $.cookie('user_key', user.user_key);
                show_error('Успешно', 3000);
                setTimeout(function () {
                    if (form.data('redirect') == undefined || form.data('redirect') == ''){
                        window.location.href = back_url('find', ['/courses', "/course_description", "/attachment"], '/cabinet');
                    } else {
                        window.location.href = form.data('redirect');
                    }
                }, 1000);

            },
            error  : function () {
                show_error('Произошла ошибка авторизации', 3000);
            }
        });
    });

    // регистрация пользователя
    $(".js_registrationUser #submit").click(function (e) {
        e.preventDefault();
        validate();
        var endAction = function () {
            var btn = $(".js_registrationUser #submit");
            var form = btn.closest("form");
            var data = form.serialize();

            show_error('Подождите чуть-чуть!');
            return $.ajax({
                type   : 'POST',
                url    : '/api/v1/sessions/registration',
                data   : data,
                success: function (m) {
                    fbq_env('CompleteRegistration');
                    $.cookie('user_key', m.user_key);
                    show_error('Успешно', 3000);
                    warning("На вашу почту отправленно письмо с сылкой для подтверждением аккаунта!", "ОК", function(){})
                    // if (form.data('redirect') == undefined){
                    //     $("#formCourseRegPopUp").show();
                    // } else {
                    //     window.location.href = form.data('redirect');
                    // }
                },
                error  : function (m) {
                    show_error(m.responseJSON.error, 3000);
                }
            });
        };
        endAction();
        // if ($(".js_registrationUser input.error").length == 0){
        //     include_phone($('.form-control[type="tel"]'), endAction);
        // }
    });
    /////////////

    $("form.auth__enter input.validInput").change(function (e) {
        changeErrorInput(e);
    });


    $("input[name='user[password]'], input[name=password_repeat]").change(function (e) {
        if ($(".auth__enter .btn-holder #submit").length){
            changePassword(e);
        }
    });

    $(".auth__reg-selected").click(function (e) {
        openSelect(e);
    });

    $(".auth__reg-select-list-item").click(function (e) {
        changeSelect(e);
    });

    //$("input[name=corporate]").change(function (e) {
    //    changeRegInput(e);
    //});

    //$("input.corporate_acc").change(function (e) {
    //    changeRegInput(e);
    //});

    //$("input[name=agreed]").change(function (e) {
    //    changeRegInput(e);
    //});
    //
    //$(".auth__submit").click(function (e) {
    //    validate(e);
    //});

    $("input.error").keyup(function (e) {
        changeErrorInput(e);
    });

    //changeRegInput = function (e) {
    //    if ($(e.target).val()){
    //        return this.getInput();
    //    }
    //};

    changeErrorInput = function (e) {
        if ($(e.target).val()){
            $(e.target).removeClass('error');
        } else {
            $(e.target).addClass('error');
        }
    };

    changePassword = function (e) {
        var pass, pass_repeat;
        pass = $('input[name="user[password]"]').val();
        pass_repeat = $('input[name=password_repeat]').val();
        if (pass === pass_repeat){
            $('input[name=password_repeat]').removeClass('error');
        } else {
            if (pass_repeat.length){
                $('input[name=password_repeat]').addClass('error');
            } else {
                $('input[name=password_repeat]').removeClass('error');
            }
        }
    };

    openSelect = function (e) {
        $(e.target).closest('.auth__reg-select').find('.auth__reg-select-list').addClass('active');
    };

    changeSelect = function (e) {
        if ($(e.target).hasClass('corporate')){
            this.$('.corporate_acc').addClass('active');
        } else {
            ! this.$('.corporate_acc').removeClass('active');
            this.$('.corporate_acc input').val('');
        }
        $(e.target).closest('.auth__reg-select').find('.auth__reg-selected').html('' + $(e.target).html() + '');
        $(e.target).closest('.auth__reg-select').find('.auth__reg-select-list').removeClass('active');
    };

    validate = function () {
        $.each($('input'), function (k, el) {
            var block = $(el);
            if (! block.val()){
                block.addClass('error').closest(".com__input-item").addClass("error");
            } else {
                block.removeClass('error').closest(".com__input-item").removeClass("error");
            }
            if (block.attr("name") == "user[email]"){
                if (validateEmail(block.val())){
                    block.removeClass('error').closest(".com__input-item").removeClass("error");
                } else {
                    block.addClass('error').closest(".com__input-item").addClass("error");
                }
            }
            if (block.attr("name") == "company[name]"){
                if (! block.closest(".corporate_acc").hasClass("active")){
                    block.removeClass("error").closest(".com__input-item").removeClass("error");
                }
            }
            if (block.attr("id") == "paramsInputTypeAccount"){
                block.removeClass("error").closest(".com__input-item").removeClass("error");
            }
        });

        if (! $('input.checkbox').is(':checked')){
            $('input.checkbox').addClass('error');
        }
        var inputPass = $("input[name='user[password]']");
        var inputRePass = $("input[name='password_repeat']");

        if ((inputPass.val() != inputRePass.val()) || (inputPass.count_text_input() <= 3)){
            inputPass.addClass("error");
            inputRePass.addClass("error");
            if (inputPass.count_text_input() > 0){
                if (inputPass.count_text_input() <= 3) show_error('Короткий пароль', 3000);
                if (inputPass.val() != inputRePass.val()) show_error('Проверьте правильность повтора пороля', 3000);
            } else {
                show_error('Поле не может быть пустым', 3000);
            }
            $("#alert").css("z-index", "9999");
        } else {
            inputPass.removeClass("error");
            inputRePass.removeClass("error");
        }
    };

    if ($.cookie('user_phone') != undefined && $.cookie('user_phone') != '' && current_user()){
        CurrentUserUpdatePhone($.cookie('user_phone'));
        $.cookie('user_phone', '');
    }
});
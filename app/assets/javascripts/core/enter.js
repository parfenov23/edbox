function validateEmail($email) {
    var emailReg = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    return emailReg.test($email);
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
function fixed_btn_save(){
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

$(document).ready(function () {
    if ($("form.js_registrationUser").length){
        (function() {
            $('.phoenix-input').phoenix();

            $('[data-phoenix-action]').on('click', function(e) {
                $('.phoenix-input').phoenix($(this).data('phoenix-action'));
                e.preventDefault();
                return e.stopPropagation();
            });

        }).call(this);
        var val_inp = $("input[name='company[name]']");
        var selected = $(".js_registrationUser .auth__reg-selected");
        var input_corp_name = $(".js_registrationUser .input-wrp.corporate_acc");
        if (val_inp.count_text_input()){
            selected.text("Корпоративный аккаунт");
            input_corp_name.addClass("active");
        }else{
            input_corp_name.removeClass("active");
            selected.text("Персональный аккаунт");
        }
    }

    $(window).scroll(function () {
        fixed_btn_save();
    });
    $(window).resize(function () {
        fixed_btn_save();
    });
    fixed_btn_save();
    $(".auth__enter-first .btn-holder #submit").click(function (e) {
        e.preventDefault();
        var btn = $(this);
        var form = btn.closest("form");
        var data = form.serialize();
        $.ajax({
            type   : 'POST',
            url    : '/api/v1/sessions/auth',
            data   : data,
            success: function (user) {
                $.cookie('user_key', user.user_key);
                window.location.href = '/cabinet';
            },
            error  : function () {
                show_error('Произошла ошибка авторизации', 3000);
            }
        });
    });

    $(".auth__enter .btn-holder #submit").click(function (e) {
        //e.preventDefault();
        //validate();
        //if ($("input.error").length == 0){
        //    var btn = $(this);
        //    var form = btn.closest("form");
        //    var data = form.serialize();
        //
        //    //var company, data, user;
        //    //user = _.omit(data, 'password_repeat', 'agreed', 'name');
        //    //company = _.pick(data, 'name');
        //    //console.log(user, company);
        //    show_error('Подождите чуть-чуть!', 5000);
        //    return $.ajax({
        //        type   : 'POST',
        //        url    : '/api/v1/sessions/registration',
        //        data   : data,
        //        //data   : {
        //        //    user   : user,
        //        //    company: company
        //        //},
        //        success: function (m) {
        //            $.cookie('user_key', m.user_key);
        //            window.location.href = '/cabinet';
        //        },
        //        error  : function () {
        //            show_error('Произошла ошибка регистрации', 3000);
        //        }
        //    });
        //}
    });

    $("form.auth__enter input.validInput").change(function (e) {
        changeErrorInput(e);
    });


    $("input[name='user[password]'], input[name=password_repeat]").change(function (e) {
        changePassword(e);
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
            }else{
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
                block.addClass('error');
            }else{
                block.removeClass('error');
            }
            if (block.attr("name") == "user[email]"){
                if(validateEmail(block.val())){
                    block.removeClass('error');
                }else{
                    block.addClass('error');
                }
            }
            if (block.attr("name") == "company[name]"){
                if(! block.closest(".corporate_acc").hasClass("active")){
                    block.removeClass("error");
                }
            }
        });

        if (! $('input.checkbox').is(':checked')){
            $('input.checkbox').addClass('error');
        }
        var inputPass = $("input[name='user[password]']");
        var inputRePass = $("input[name='password_repeat']");

        if ((inputPass.val() != inputRePass.val()) || (inputPass.count_text_input() <= 3)) {
            inputPass.addClass("error");
            inputRePass.addClass("error");
            show_error('Короткий пароль', 3000);
            $("#alert").css("z-index", "9999");
        }else{
            inputPass.removeClass("error");
            inputRePass.removeClass("error");
        }
    }
});
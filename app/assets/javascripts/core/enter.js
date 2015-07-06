$(document).ready(function () {
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
        e.preventDefault();
        validate();
        if ($("input.error").length == 0){
            var btn = $(this);
            var form = btn.closest("form");
            var data = form.serialize();

            //var company, data, user;
            //user = _.omit(data, 'password_repeat', 'agreed', 'name');
            //company = _.pick(data, 'name');
            //console.log(user, company);
            show_error('Подождите чуть-чуть!', 5000);
            return $.ajax({
                type   : 'POST',
                url    : '/api/v1/sessions/registration',
                data   : data,
                //data   : {
                //    user   : user,
                //    company: company
                //},
                success: function (m) {
                    $.cookie('user_key', m.user_key);
                    window.location.href = '/cabinet';
                },
                error  : function () {
                    show_error('Произошла ошибка регистрации', 3000);
                }
            });
        }
    });

    $("form.auth__enter input.validInput").change(function (e) {
        changeErrorInput(e);
    });


    $("input[name=password], input[name=password_repeat]").change(function (e) {
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

    $(".auth__submit").click(function (e) {
        validate(e);
    });

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
        pass = this.$('input[name=password]').val();
        pass_repeat = this.$('input[name=password_repeat]').val();
        if (pass === pass_repeat){
            $('input[name=password_repeat]').removeClass('error');
        } else {
            $('input[name=password_repeat]').addClass('error');
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
    }

    validate = function () {
        var arr, data;
        _.each(this.$('input'), function (el) {
            if (! $(el).val()){
                $(el).addClass('error');
            }
        });
        if (! $('input.checkbox').is(':checked')){
            $('input.checkbox').addClass('error');
        }
        //data = this.getInput();

        //var btn = $(this);
        //var form = btn.closest("form");
        //var data = form.serialize();

        //arr = _.map(data, function (v, k) {
        //    if (_.isBoolean(v)){
        //        return v;
        //    } else if (_.isString(v)){
        //        return v !== '';
        //    }
        //});
        //setTimeout((function (_this) {
        //    return function () {
        //        if (_.isEqual(arr, [true, true, true, true, true, true, true])){
        //            return _this.post();
        //        } else if (_.isEqual(arr, [true, true, true, false, true, true, true])){
        //            return _this.post();
        //        } else {
        //            return _this.show_error('Заполните все поля', 5000);
        //        }
        //    };
        //})(this), 1000);
    }
})
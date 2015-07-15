//= require ./jquery-2.1.3.min
//= require ./vendor/jquery-ui.min
//= require ./vendor/jquery.cookie
//= require ./vendor/zbaron.min
//= require ./vendor/material.min
//= require ./vendor/jquery-migrate-1.2.1.min.js

//= require_tree ./core

//=require main/main

$(document).ajaxSend(function (event, jqxhr, settings) {
    jqxhr.setRequestHeader('USER-KEY', $.cookie('user_key'));
});




$(document).ready(function () {

    $('.favorite-courses .favorite-item .description .header .ingroup').hover(function () {
        $(this).find('.group-list').show();
    }, function () {
        $(this).find('.group-list').hide();
    });

    $('body').on('click', function (e) {
        var list;
        $(document).trigger('click.dropdown');
        list = $(e.target).closest('.select').find('ul.hidden').show();
        $(document).bind('click.dropdown', function (ev) {
            if (e.target !== ev.target){
                list.hide();
                return $(document).unbind('click.dropdown');
            }
        });
    });

    show_error = function (text, duration) {
        var el = $('#alert');
        el.find('.text').text(text);
        el.show(300);
        el.find('.close').click(function () {
            el.hide(400);
        });
        setTimeout(function () {
            el.hide(400);
        }, duration);
    }

    setTimeout(function () {
        var windowHeight = $(window).outerHeight();
        $('.auth').css({'height': windowHeight + 'px'});
    }, 100);


    $('.filter-category .more .icon').on('click', function () {
        $(this).closest('.more').removeClass('hidden');
    })


    $('.header__bottom .aside-trigger').on('click', function () {
        var id = $(this).data('id');
        if ($('#' + id + '').hasClass('show')){
            $('#' + id + '').toggleClass('show');
        }
        else {
            $('.courses-aside:visible').removeClass('show');
            $('#' + id + '').toggleClass('show');
        }
    })

    $('.datapicker__trigger').datepicker({
        prevText       : '&#x3c;Пред',
        nextText       : 'След&#x3e;',
        currentText    : 'Сегодня',
        monthNames     : ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'],
        monthNamesShort: ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн', 'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек'],
        dayNames       : ['воскресенье', 'понедельник', 'вторник', 'среда', 'четверг', 'пятница', 'суббота'],
        dayNamesShort  : ['вск', 'пнд', 'втр', 'срд', 'чтв', 'птн', 'сбт'],
        dayNamesMin    : ['Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб'],
        dateFormat     : 'dd.mm.yy',
        firstDay       : 1,
        isRTL          : false,
        beforeShow     : function () {
            return $('#ui-datepicker-div').addClass('hide');
        },
        onSelect       : function (e) {
          var dates = $(this).data('datepicker');
          var selectDate = dates.currentDay + '/' + dates.currentMonth + '/' + dates.currentYear
          $(this).parent().find('.selected-value').html(selectDate)
          return $(this).parent().addClass('show');
        }
    });
    $('.ui-state-default').on('click', function (e) {
    })
    $('.datapicker__trigger').on('click', function () {
        $('#ui-datepicker-div').removeClass('hide');
    });

    figcaptionTitleEclipses = function (el, height) {
        var heights = [];
        $(el).each(function (indx, element) {
            if ($(element).height() > height){
                $(element).addClass('over-title')
            }
        });
    };

    $('.filter-courses').baron();

    profileDataChange = function () {
        $('.profile__main #submit').click(function () {
            var data = $('.profile__main').serialize();
            $.ajax({
                type: 'POST',
                url : '/api/v1/users',
                data: data
            }).success(function () {
                console.log('111');
                show_error('Успешно сохранено', 3000);
            }).error(function () {
                console.log('111');
                show_error('Ошибка', 3000);
            });
        });
    }

    profilePasswordChangeValidation = function () {
        $('#profile input').blur(function () {
            var pass = $('#profile input[name=password]').val();
            var pass_repeat = $('#profile input[name=password_repeat]').val();
            if (pass == pass_repeat){
                $('#profile input[name=password_repeat]').removeClass('error');
            }
            else {
                $('#profile input[name=password_repeat]').addClass('error');
            }
        });
    }

    profilePasswordChange = function () {
        $('.profile__password #submit').click(function () {
            var data = $('.profile__password input[name=password]').serialize();
            $.ajax({
                type: 'POST',
                url : '/api/v1/users/change_password',
                data: data
            }).success(function () {
                show_error('Успешно сохранено', 3000);
            }).error(function () {
                show_error('Ошибка', 3000);
            });
        });
    }

    headerUserToggle = function () {
        $(document).on('click', function (e) {
            if ($(e.target).closest('.header__user').length == 0){
                $('.menu__user').removeClass('active');
            }
            else if ($(e.target).closest('.header__user').length == 1){
                if ($(e.target)[0].className == 'ava'){
                    $('.menu__user').toggleClass('active');
                }
                else {
                    $('.menu__user').addClass('active');
                }
            }
        });
    }

    changeAvatar = function (e) {
        $('.profile__main .upload__block input').change(function () {
            var data = new FormData();
            data.append('avatar', $('input[type=file]')[0].files[0]);
            $.ajax({
                type       : 'POST',
                url        : '/api/v1/users/update_avatar',
                data       : data,
                cache      : false,
                contentType: false,
                processData: false,
            }).success(function (data) {
                console.log(data);
                console.log(data.base64);
                $('.profile__main .ava').attr('src', 'data:image/png;base64,' + data.base64);
                show_error('Ваш новый аватар готов', 3000);
            }).error(function () {
                show_error('Не удалось обновить аватар', 3000);
            });
        });
    }


    profileDataChange();
    profilePasswordChangeValidation();
    profilePasswordChange();
    figcaptionTitleEclipses('.corses-prev figcaption .title', 84);
    figcaptionTitleEclipses('.favorite-item .description .title', 56);

    headerUserToggle();

    changeAvatar();

});

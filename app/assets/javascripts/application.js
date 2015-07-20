//= require ./jquery-2.1.3.min
//= require ./vendor/jquery-ui.min
//= require ./vendor/jquery.cookie
//= require ./vendor/zbaron.min
//= require ./vendor/material.min
//= require ./vendor/jquery.jcarousel.min
//= require ./vendor/jquery-migrate-1.2.1.min.js
//=require main/main

//= require_tree ./core


$(document).ajaxSend(function (event, jqxhr, settings) {
    jqxhr.setRequestHeader('USER-KEY', $.cookie('user_key'));
});

var includeDatePicker = function(){
    $('.datapicker__trigger, .js__set-date').datepicker({
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
}


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


    $('.ui-state-default').on('click', function (e) {
    })

    includeDatePicker()

    $(document).on('click', '.datapicker__trigger', function () {
        $('#ui-datepicker-div').removeClass('hide');
    });



    $('.filter-courses, .js__baron').baron();



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


    headerUserToggle();
    changeAvatar();

});

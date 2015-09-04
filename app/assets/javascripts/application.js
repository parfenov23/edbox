//= require ./jquery-2.1.3.min
//= require ./vendor/jquery-ui.min
//= require ./vendor/jquery.cookie
//= require ./vendor/zbaron.min
//= require ./vendor/jquery.jcarousel.min
//= require ./vendor/jquery-migrate-1.2.1.min.js
//= require ./vendor/notifymy.js

//= require ./vendor/material/ripples
//= require ./vendor/material/material
//= require ./vendor/jquery.phoenix
//= require ./vendor/fullscrn
//= require main/main

//= require_tree ./core

//= require websocket_rails/main
//= require_tree ./websocket
//= require_tree ./contenter

function SetCaretAtEnd(elem) {
    var elemLen = elem.value.length;
    // For IE Only
    if (document.selection){
        // Set focus
        elem.focus();
        // Use IE Ranges
        var oSel = document.selection.createRange();
        // Reset position to 0 & then set at end
        oSel.moveStart('character', - elemLen);
        oSel.moveStart('character', elemLen);
        oSel.moveEnd('character', 0);
        oSel.select();
    }
    else if (elem.selectionStart || elem.selectionStart == '0'){
        // Firefox/Chrome
        elem.selectionStart = elemLen;
        elem.selectionEnd = elemLen;
        elem.focus();
    } // if
}

function bindEventDocument(hash) {
    $.each(hash.arrElem, function (n, elem) {
        var func_name = elem.replace(".js_", "").replace(".js__", "").replace(".", "");
        var parent_block = '';
        if (hash.parentBlock != undefined){
            parent_block = hash.parentBlock
        }
        $(document).on(hash.nameAction, parent_block + ' ' + elem, eval(func_name));
    });
}

(function ($) {
    $.fn.serializefiles = function () {
        var obj = $(this);
        /* ADD FILE TO PARAM AJAX */
        var formData = new FormData();
        $.each($(obj).find("input[type='file']"), function (i, tag) {
            $.each($(tag)[0].files, function (i, file) {
                formData.append(tag.name, file);
            });
        });
        var params = $(obj).serializeArray();
        $.each(params, function (i, val) {
            formData.append(val.name, val.value);
        });
        return formData;
    };
})(jQuery);

$.fn.count_text_input = function () {
    // .replace(/\W/gi," ")
    var text_block;
    var tag_name = $(this).prop("tagName");
    var valid_tag = ["INPUT", "TEXTAREA"];
    if ($.inArray(tag_name, valid_tag) > - 1){
        text_block = $(this).val();
    } else {
        text_block = $(this).text();
    }
    var first_input_text = text_block.replace(/\n/, " ").replace(/\s{2,}/gi, " ").replace(/ $/, "").replace(/^ /, "");
    return first_input_text.length
};

$(document).ajaxSend(function (event, jqxhr, settings) {
    jqxhr.setRequestHeader('USER-KEY', $.cookie('user_key'));
});

var goToProgramAttachment = function(){
    var block = $(".js_goToProgramAttachment");
    if ( block.length ){
        var block_scroll = $('.js_blockAttachmentInProgram[data-id="' + block.data('id') + '"]');
        $('body, html').scrollTop( block_scroll.position().top );
    }
}

var elemFullScreen = function(elem, btn){
    var fsButton = btn,
        fsElement = elem;
    if (window.fullScreenApi.supportsFullScreen) {
        //console.log('YES: Your browser supports FullScreen');
        //console.log('fullScreenSupported');

        // handle button click
        fsButton.addEventListener('click', function() {
            window.fullScreenApi.requestFullScreen(fsElement);
        }, true);

        fsElement.addEventListener(fullScreenApi.fullScreenEventName, function() {
            if (fullScreenApi.isFullScreen()) {
                //console.log('Whoa, you went fullscreen');
            } else {
                elem.pause();
            }
        }, true);

    } else {
        //console.log('SORRY: Your browser does not support FullScreen');
    }
}

var includeDatePicker = function (block) {
    if (block != undefined){
        block.datepicker({
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
            minDate        : new Date(),
            beforeShow     : function () {
                return $('#ui-datepicker-div').addClass('hide');
            },
            onSelect       : function (e) {
                var dates = $(this).data('datepicker');
                var selectDate = dates.currentDay + '/' + (dates.currentMonth + 1) + '/' + dates.currentYear
                $(this).parent().find('.selected-value').html(selectDate);
                if ($(this).hasClass("js_changeDateToDatePicker")){
                    changeDateToDatePicker($(this));
                }
                $(this).change();
                return $(this).parent().addClass('show');
            }
        });
    }
}

function pageLoad(action) {
    $(document).ready(action);
}

var notifyMypush = function (message) {
    var options = {
        icon   : 'http://i.istockimg.com/file_thumbview_approve/46749378/3/stock-illustration-46749378-cute-piglet-icon-animal-icons-series.jpg',
        body   : message.body,
        onclick: function () {
            console.log("Good");
        },
        onerror: function () {
            console.log("On Error Triggered");
        },
        onclose: function () {
            console.log("On Close Triggered");
        }
    };
    NotifyMe.launch(message.title, options);
}

var adaptiveTitle = function () {
    return $('.adaptive__title').each(function () {
        var rightWidth;
        rightWidth = $(this).find('.right-col').width();
        return $(this).find('.left-col').css({
            width: $(this).width() - rightWidth + 'px'
        });
    });
};

function extractEmails(text) {
    return text.match(/([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9._-]+)/gi);
}

Array.prototype.getUnique = function () {
    var u = {}, a = [];
    for (var i = 0, l = this.length; i < l; ++ i){
        if (u.hasOwnProperty(this[i])){
            continue;
        }
        a.push(this[i]);
        u[this[i]] = 1;
    }
    return a;
}
var optionDatePicker = function () {
    var btn = $(this);
    //setTimeout(function(){
    var bl_dt = $('.datapicker__trigger');
    btn.datepicker("destroy");
    includeDatePicker($('.datapicker__trigger, .js__set-date'));
    if (btn.data('min-date')){
        btn.datepicker("option", "minDate", new Date(btn.data('min-date')));
    } else {
        btn.datepicker("option", "minDate", new Date());
    }
    if (btn.data('max-date')){
        btn.datepicker("option", "maxDate", new Date(btn.data('max-date')));
    } else {
        btn.datepicker("option", "maxDate", null);
    }
    btn.datepicker('show');
    installPositionBlock($("#ui-datepicker-div"))
    //}, 3000)
}

var installPositionBlock = function(block){
    var dp_top = block.offset().top;
    var px_block = view_px_block(block);
    if (px_block < block.outerHeight()){
        block.css('top', (dp_top - ( block.outerHeight() - px_block ) + 30))
    }
}

function parseDate(input) {
    var parts = input.split('.');
    // new Date(year, month [, day [, hours[, minutes[, seconds[, ms]]]]])
    return new Date(parts[2], parts[1]-1, parts[0]); // Note: months are 0-based
}
var for_tooltip = function() {
    return $('.js_for-tooltip').hover(function() {
        return $(this).find('.js_tooltip').addClass('is-active');
    }, function() {
        return $(this).find('.js_tooltip').removeClass('is-active');
    });
};
$(document).ready(function () {
    goToProgramAttachment();
    includeDatePicker($('.datapicker__trigger.incDocumentReady'));
    $(document).on('click', '.datapicker__trigger', optionDatePicker);
    jQuery.each(jQuery('textarea[data-autoresize]'), function () {
        var offset = this.offsetHeight - this.clientHeight;

        var resizeTextarea = function (el) {
            jQuery(el).css('height', 'auto').css('height', el.scrollHeight + offset);
        };
        resizeTextarea(this);
        jQuery(this).on('keyup input click', function () { resizeTextarea(this); }).removeAttr('data-autoresize');
    });

    $.material.init()

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
        var bodyHeight = $('body').outerHeight();
        if ($('.auth').hasClass('is__course-description')){
            $('.auth').css({'height': (bodyHeight + 312) + 'px'});
            console.log(bodyHeight);
        }
        else {

        }
    }, 100);


    $('.filter-category .more .icon').on('click', function () {
        $(this).closest('.more').removeClass('hidden');
    })

    $('.js_openLeftSideBar').on('click', function () {
        var id = $(this).data('id');
        if ($('#' + id + '').hasClass('show')){
            $('#' + id + '').toggleClass('show');
            $('.js__backing').toggleClass('is__active');
        }
        else {
            $('.courses-aside:visible').removeClass('show');
            $('#' + id + '').toggleClass('show');
            $('.js__backing').toggleClass('is__active');
        }
    })


    $('.ui-state-default').on('click', function (e) {
    })

    //includeDatePicker()

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

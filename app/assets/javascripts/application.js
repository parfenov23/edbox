//= require ./jquery-2.1.3.min
//= require ./vendor/jquery-ui.min
//= require ./vendor/jquery.cookie
//= require ./vendor/zbaron.min
//= require ./vendor/jquery.jcarousel.min
//= require ./vendor/owl.carousel
//= require ./vendor/jquery-migrate-1.2.1.min.js
//= require ./vendor/notifymy.js

//= require ./vendor/material/ripples
//= require ./vendor/material/material
//= require ./vendor/jquery.phoenix
//= require ./vendor/fullscrn
//= require_tree ./main

//= require_tree ./core

//= require websocket_rails/main
//= require_tree ./websocket
//= require_tree ./contenter

function declOfNum(number, titles) {
    cases = [2, 0, 1, 1, 1, 2];
    return titles[(number % 100 > 4 && number % 100 < 20)?2:cases[(number % 10 < 5)?number % 10:5]];
}

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

var goToProgramAttachment = function () {
    var block = $(".js_goToProgramAttachment");
    if (block.length){
        var block_scroll = $('.js_blockAttachmentInProgram[data-id="' + block.data('id') + '"]');
        $('body, html').scrollTop(block_scroll.position().top);
    }
}

var elemFullScreen = function (elem, btn) {
    var fsButton = btn,
        fsElement = elem;
    if (window.fullScreenApi.supportsFullScreen){
        //console.log('YES: Your browser supports FullScreen');
        //console.log('fullScreenSupported');

        // handle button click
        fsButton.addEventListener('click', function () {
            window.fullScreenApi.requestFullScreen(fsElement);
        }, true);

        fsElement.addEventListener(fullScreenApi.fullScreenEventName, function () {
            if (fullScreenApi.isFullScreen()){
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
};

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
};

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
};
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
    installPositionBlock($("#ui-datepicker-div"));
    //}, 3000)
};

var installPositionBlock = function (block) {
    if (block.length){
        var dp_top = block.offset().top;
        var px_block = view_px_block(block);
        if (px_block < block.outerHeight()){
            block.css('top', (dp_top - ( block.outerHeight() - px_block ) + 30));
        }

    }
};

Array.prototype.clean = function (deleteValue) {
    for (var i = 0; i < this.length; i ++){
        if (this[i] == deleteValue){
            this.splice(i, 1);
            i --;
        }
    }
    return this;
};

function parseDate(input) {
    var parts = input.split('.');
    // new Date(year, month [, day [, hours[, minutes[, seconds[, ms]]]]])
    return new Date(parts[2], parts[1] - 1, parts[0]); // Note: months are 0-based
}
var for_tooltip = function () {
    return $('.js_for-tooltip').hover(function () {
        return $(this).find('.js_tooltip').addClass('is-active');
    }, function () {
        return $(this).find('.js_tooltip').removeClass('is-active');
    });
};

function myIP() {
    if (window.XMLHttpRequest) xmlhttp = new XMLHttpRequest();
    else xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");

    xmlhttp.open("GET", "http://api.hostip.info/get_html.php", false);
    xmlhttp.send();

    hostipInfo = xmlhttp.responseText.split("\n");

    for (i = 0; hostipInfo.length >= i; i ++){
        ipAddress = hostipInfo[i].split(":");
        if (ipAddress[0] == "IP") return ipAddress[1];
    }

    return false;
}

var back_url = function (type, find_link, default_result) {
    if (sessionStorage['histories'] == undefined) sessionStorage['histories'] = [];
    var array_histories = sessionStorage['histories'].split(',');
    var current_url = (location.pathname + location.search)
    if (array_histories[array_histories.length - 1] != current_url) array_histories[array_histories.length] = current_url;
    sessionStorage['histories'] = array_histories.clean("").clean("undefined");
    var result = array_histories[array_histories.length - 2];
    if (array_histories.length == 1) result = array_histories[0];
    if (array_histories.length > 35) sessionStorage['histories'] = array_histories.slice(- 10);
    if (type == "clear") sessionStorage['histories'] = "";
    if (type == "find"){
        var validate_search = false;
        $.each(array_histories.reverse(), function (n, e) {
            for (var i = 0; i < find_link.length; i ++){
                if (e.search(find_link[i]) >= 0){
                    validate_search = true;
                    break;
                }
            }
            if (validate_search){
                result = e;
                return false;
            }
        });
        if (default_result != undefined && ! validate_search) result = default_result;
    }
    if (type == "all") result = array_histories;
    if (result == "" || result == undefined) result = "/";
    return result;
}

$(document).ready(function () {
    back_url();
    $(document).on('click', '.js_closeAllPopup', function (e) {
        if ($(e.target).hasClass("js_closeAllPopup")) $(this).hide()
    });

    $(document).on('click', 'figure.basic__module, figure.shot__module', function (e) {
        var cabinte_block_valid = (! $(e.target).closest(".com__director-btn").length && ! $(e.target).hasClass(".com__director-btn"))
        if (! $(e.target).closest(".action-btn").length && ! $(e.target).hasClass("action-btn") && cabinte_block_valid){
            if(!$(e.target).hasClass("action__menu") && !$(e.target).closest(".action__menu").length){
                var link = $(this).find("a.goToCourse");
                if (link.length){
                    link[0].click();
                } else {
                    link = $(this).find(".title .inner").attr("onclick").replace("window.location.href=", '').replace('"', '').replace('"', '')
                    window.location.href = link;
                }
            }
        }
    });

    $(document).on('click', '.webinar__teaser .action__block.js_addCourseToMyCourse a', function (e) {
        var link = $(this).attr('href');
        e.preventDefault();
        setTimeout(function () {
            window.location.href = link
        }, 500);

    });

    $(document).on('click', function (e) {
        if (! $(e.target).closest(".js__select-calendar").length){
            $(".js__select-calendar.is__active").removeClass("is__active")
                .find(".hidden-calendar").hide()
        }
    });

    $(document).on('click', '.programm__block', function (e) {
        if ($(e.target).hasClass("programm__block") || $(e.target).closest(".programm__block.is__shot")){
            if (! $(e.target).closest(".programm__wrp").length){
                if ($(this).find("i.ckick_shot").length && ! $(e.target).hasClass("ckick_shot")){
                    $(this).toggleClass("is__shot");
                }
            }
        }
    })

    if ($("input[name='ip_user']").length) $("input[name='ip_user']").val(myIP());
    $("input[name='current_link_page']").val(window.location.href);

    $('video').bind('contextmenu', function () { return false; });
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

    $.material.init();

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
        if (duration){
            setTimeout(function () {
                el.hide(400);
            }, duration);
        }

    };

    setTimeout(function () {
        var windowHeight = $(window).outerHeight();
        var bodyHeight = $('body').outerHeight();
        if ($('.auth').hasClass('is__course-description')){
            $('.auth').css({'height': (bodyHeight + 312) + 'px'});
        }
        else {

        }
    }, 100);


    $('.filter-category .more .icon').on('click', function () {
        $(this).closest('.more').removeClass('hidden');
    });
    $(document).on('click', ".js_openLeftSideBar", function () {
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
    });


    $('.ui-state-default').on('click', function (e) {
    });

    //includeDatePicker()

    $(document).on('click', '.datapicker__trigger', function () {
        $('#ui-datepicker-div').removeClass('hide');
    });


    $('.filter-courses, .js__baron').baron();


    headerUserToggle = function () {
        $(document).on('click', function (e) {
            if ($(e.target).closest('.header__user').length === 0){
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
    };

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

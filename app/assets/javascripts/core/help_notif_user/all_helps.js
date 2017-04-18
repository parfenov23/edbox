function all_helps() { //весь массив помощи
    var arr_help = [
        {
            block         : "",
            color         : "#6A199A",
            btn_text      : "ПРОЙТИ ОБУЧЕНИЕ ЗА 30 СЕКУНД",
            btn_close_text: "ПРОПУСТИТЬ ОБУЧЕНИЕ",
            btn_next_css  : {width: 260},
            btn_color     : "#9B65BB",
            title         : "Добро пожаловать в Онлайн университет по продажам рекламы ADCONSULT Online.",
            content       : "Буквально несколько слов о том как тут все устроено, хорошо?"
        },
        {
            block     : "#page__header .left-col .page__icon.item",
            btn_text  : "ДАЛЕЕ",
            color     : "#1565C0",
            btn_color : "#54D2E2",
            //btn_action: "open_right_bar_tags",
            skip_btn  : true,
            text_align: "left",
            content   : "Именно здесь находится кнопка меню, доступ к основным функциям."
        },
        {
            block     : ".right-col .page__action .item .help",
            btn_text  : "ДАЛЕЕ",
            color     : "#4527A0",
            btn_color : "#54D2E2",
            //btn_action: "close_right_bar_tags",
            skip_btn  : true,
            text_align: "left",
            content   : "Нужна помощь? В разделе FAQ — подробные видеоуроки об использовании сервиса ADCONSULT Online"
        },
        {
            block     : ".right-col .page__action .item .notification_i",
            btn_text  : "ДАЛЕЕ",
            color     : "#6A1B9A",
            btn_color : "#54D2E2",
            skip_btn  : true,
            text_align: "left",
            content   : "Все оповещния о новых курсах и материалах — тут."
        },
        {
            block     : ".right-col .page__action .item.ava",
            btn_text  : "ДАЛЕЕ",
            color     : "#00838F",
            btn_color : "#54D2E2",
            skip_btn  : true,
            text_align: "left",
            content   : "Ваш аккаунт и все ваши сертификаты."
        },
        {
            block     : "#page__header .left-col .page__children",
            btn_text  : "ДАЛЕЕ",
            color     : "#0277BD",
            btn_color : "#54D2E2",
            //btn_action: "open_left_all_menu",
            skip_btn  : true,
            text_align: "left",
            content   : "Это наша библиотека."
        },
        //{
        //    block     : "#page__header .left__aside-main-nav",
        //    btn_text  : "Я ЗАПОМНИЛ",
        //    color     : "#00BCD4",
        //    btn_color : "#54D2E2",
        //    btn_action: "close_left_all_menu",
        //    skip_btn  : true,
        //    text_align: "left",
        //    content   : "Вот это меню, потом повыбирай разделы, посмотри может что то понравится"
        //},
        {
            block     : ".inner-content .category__filter_list .btn.js_openLeftSideBar",
            btn_text  : "ДАЛЕЕ",
            color     : "#00695C",
            btn_color : "#54D2E2",
            skip_btn  : true,
            text_align: "left",
            content   : "А это — поиск по всем материалам."
        },
        {
            block       : ".inner-content .category__filter_list .sortTableCourses",
            btn_text    : "НАЧАТЬ РАБОТУ",
            //btn_close_text: "НАЧАТЬ РАБОТУ",
            btn_next_css: {width: 190},
            skip_btn    : true,
            btn_action  : "go_to_index",
            color       : "#4527A0",
            btn_color   : "#54D2E2",
            text_align  : "left",
            content     : "Простая сортировка."
        }

    ];
    return arr_help;
}

function pause(n) {
    var today = new Date();
    var today2 = today;
    while ((today2 - today) <= n){
        today2 = new Date()
    }
}

function actions_help(type) { // действия при нажатие на кнопку далее
    if (type == "go_to_profile"){
        window.location.href = "/profile"
    }
    if (type == "go_to_index"){
        window.location.href = "/courses"
    }
    //////////////
    if (type == "open_right_bar_tags"){
        var css_bar = {"-webkit-transition": "all 0m", transition: "all 0ms", right: "0"};
        $("#js-filter-courses").css(css_bar);
    }
    if (type == "close_right_bar_tags"){
        var block = $("#js-filter-courses");
        var css_bar = {right: "-100%"};
        block.css(css_bar);
        block.css({"-webkit-transition": "all 300ms", transition: "all 300ms"});
    }
    ////////////////
    //if (type == "open_left_all_menu"){
    //    var css_bar = {"-webkit-transition": "all 0m", transition: "all 0ms", left: "0"};
    //    $(".left__aside-main-nav").css(css_bar);
    //}
    //if (type == "close_left_all_menu"){
    //    var block = $(".left__aside-main-nav");
    //    var css_bar = {right: "-150%"};
    //    block.css(css_bar);
    //    block.attr('style', '');
    //}
    ////////////////
}
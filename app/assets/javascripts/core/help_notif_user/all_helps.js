function all_helps() { //весь массив помощи
    var arr_help = [
        {
            block         : "",
            color         : "#6A199A",
            btn_text      : "ПОЕХАЛИ",
            btn_close_text: "ПРОПУСТИТЬ РАССКАЗ",
            btn_color     : "#9B65BB",
            title         : "Привет! Мы рады приветствовать тебя" +
            "</br>в системе ADCONSULT.ONLINE.",
            content       : "Сейчас, в течении одной минуты мы расскажем тебе " +
            "об основных элементах системы. Если готов, то нажми на кнопку Поехали."
        },
        {
            block     : ".inner-content .category__filter_list .js_openLeftSideBar",
            btn_text  : "ДАЛЕЕ",
            color     : "#00BCD4",
            btn_color : "#54D2E2",
            btn_action: "open_right_bar_tags",
            skip_btn  : true,
            text_align: "left",
            content   : "Это быстрый поиск по курсам, если нажать на эту кнопку откроется правый " +
            "бар, в котором можно выбрать интересующие тэги!"
        },
        {
            block     : "#js-filter-courses",
            btn_text  : "ДАЛЕЕ",
            color     : "#303F9F",
            btn_color : "#54D2E2",
            btn_action: "close_right_bar_tags",
            skip_btn  : true,
            text_align: "left",
            content   : "Это так называемы БАР! Он поможет вам быстро и удобно " +
            "использовать дополнительные фишки в ADCONSULT.ONLINE."
        },
        {
            block     : "#courses figure:first",
            btn_text  : "ДАЛЕЕ",
            color     : "#00BCD4",
            btn_color : "#54D2E2",
            skip_btn  : true,
            text_align: "left",
            content   : "Для того что бы начать проходить курсы, тебе нужно нажать на понравившийся блок курса и там дальше ты все поймешь))"
        },
        {
            block     : "#page__header .left-col .page__children ",
            btn_text  : "ДАЛЕЕ",
            color     : "#00BCD4",
            btn_color : "#54D2E2",
            skip_btn  : true,
            text_align: "left",
            content   : "Это навигационное меню! С помощью его ты можешь выбрать тип курса!"
        },
        {
            block     : "#page__header .left-col .page__icon.item",
            btn_text  : "ДАЛЕЕ",
            color     : "#00BCD4",
            btn_color : "#54D2E2",
            //btn_action: "open_left_all_menu",
            skip_btn  : true,
            text_align: "left",
            content   : "При нажатие на этот бургер, у вас откроется левое меню со всеми доступными вам пункатами"
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
            block         : ".item.ava.header__user",
            btn_text      : "ПЕРЕЙТИ В ПРОФИЛЬ",
            btn_close_text: "НАЧАТЬ РАБОТУ",
            btn_next_css  : {width: 190},
            btn_action    : "go_to_profile",
            color         : "#00BCD4",
            btn_color     : "#54D2E2",
            skip_btn      : false,
            text_align    : "left",
            content       : "В шапке отображается навигационное меню и иконка " +
            "твоего профиля. Ты можешь прямо сейчас заполнить информацию о " +
            "себе или сразу же приступить к работе."
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
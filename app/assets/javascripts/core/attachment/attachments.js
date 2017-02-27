var eventCreate = function () {
    var web_id = $(this).data('webinar_id');
    if (typeof web_id != 'undefined'){
        $.ajax({
            type: 'POST',
            url : '/api/v1/webinars/' + web_id + '/event_create'
        }).success(function () {
            window.location.reload();
        }).error(function () {
            show_error('Произошла ошибка', 3000);
        });
    }
    return true;
};

var eventStart = function () {
    var web_id = $(this).data('webinar_id');
    if (typeof web_id != 'undefined'){
        $.ajax({
            type: 'POST',
            url : '/api/v1/webinars/' + web_id + '/event_start'
        }).success(function () {
            window.location.reload();
        }).error(function () {
            show_error('Произошла ошибка', 3000);
        });
    }
    return true;
};

var eventStop = function () {
    var web_id = $(this).data('webinar_id');
    if (typeof web_id != 'undefined'){
        $.ajax({
            type: 'POST',
            url : '/api/v1/webinars/' + web_id + '/event_stop'
        }).success(function () {
            window.location.reload();
        }).error(function () {
            show_error('Произошла ошибка', 3000);
        });
    }
    return true;
};

var eventRegUser = function () {
    var btn = $(this);
    var web_id = btn.data('webinar_id');
    var user_id = btn.data('user_id');
    if (typeof web_id != 'undefined'){
        $.ajax({
            type: 'POST',
            url : '/api/v1/webinars/' + web_id + '/event_reg_user',
            data: {user_id: user_id}
        }).success(function () {
            if (btn.data('alert') != false){
                var tsucces = "Вебинар начнется " + btn.closest('form').find('.title').text() + ", мы уведомим вас за 3 часа, " +
                "а так же за 5 минут до начала вебинара на электронную почту " +
                $('.menu__user .login').text();
                warning(tsucces, 'OK');
                $('.js_actionYesStart').on('click', function () {window.location.reload()});
            } else {
                window.location.href = btn.data('href');
            }
        }).error(function () {
            show_error('Произошла ошибка', 3000);
        });
    }
    return true;
};

var eventUnRegUser = function () {
    var web_id = $(this).data('webinar_id');
    var user_id = $(this).data('user_id');
    if (typeof web_id != 'undefined'){
        $.ajax({
            type: 'POST',
            url : '/api/v1/webinars/' + web_id + '/event_un_reg_user',
            data: {user_id: user_id}
        }).success(function () {
            window.location.reload();
        }).error(function () {
            show_error('Произошла ошибка', 3000);
        });
    }
    return true;
};

goToWebinar = function(){
    if (get_browser('Safari')){
        var iframe = $(".webinar_attachment iframe");
        if (iframe.length){
            window.location.href = iframe.attr('src')
        }
    }
};

var first_enter_material = function(){
    if ($("#registration_popup").length){
        var time = new Date();
        var first_time = $.session.get("first_enter_material");
        var time_line = $("#registration_popup").data("time-line");
        if (new Date(first_time) == "Invalid Date"){
            $.session.set("first_enter_material", time);
        }
        setTimeout(function(){
            $("#registration_popup").css("display", "flex");
            pause_video_vimeo();
        }, (2 - reside_last_date_close_ads("first_enter_material"))*1000*60 );
    } 
}

var pause_video_vimeo = function(){
    if ($(".video__content iframe").length){
        var iframe = $('iframe')[0];
        var player = new Vimeo.Player(iframe);
        player.pause();
    }

}

pageLoad(function () {
    $(document).on('click', '.js_eventCreate', eventCreate);
    $(document).on('click', '.js_eventStart', eventStart);
    $(document).on('click', '.js_eventStop', eventStop);
    $(document).on('click', '.js_eventRegUser', eventRegUser);
    $(document).on('click', '.js_eventUnRegUser', eventUnRegUser);
    if ($(".webinar_attachment").length) goToWebinar();
    if ( $("#attachmentCourseProgram").length && $("#presentCurrentUser").val() == "false") first_enter_material();
});

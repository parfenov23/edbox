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

pageLoad(function(){
    $(document).on('click', '.js_eventCreate', eventCreate);
    $(document).on('click', '.js_eventStart', eventStart);
    $(document).on('click', '.js_eventStop', eventStop);
});

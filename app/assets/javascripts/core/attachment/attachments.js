var createWebRoom = function () {
    var web_id = $(this).data('webinar_id');
    if (typeof web_id != 'undefined'){
        $.ajax({
            type: 'POST',
            url : '/api/v1/webinars/' + web_id + '/create_room'
        }).success(function () {
            window.location.reload();
        }).error(function () {
            show_error('Произошла ошибка', 3000);
        });
    }
    return true;
};

pageLoad(function(){
    $(document).on('click', '.js_createWebRoom', createWebRoom);
});

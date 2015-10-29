var downloadAttachment = function (btn) {
    window.location.href = '/api/v1/attachments/' + btn.data('id') + '/render_file?hash=' + $.cookie('user_key');
};
var completeAttachment = function (btn) {
    $.ajax({
        type: 'POST',
        url : '/api/v1/attachments/' + btn.data('id') + '/complete',
        data: {bunch_section_id: btn.data('bunch_section_id')}
    }).success(function () {
        show_error('Материал пройден', 3000);
        btn.removeClass('js_completeAttachment');
        btn.find('.tooltext').text('Следующий материал');
        btn.addClass('js_redirectAttachment');
        var icon = btn.find('.icon');
        icon.removeClass('done');
        icon.addClass('next');
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

var redirectAttachment = function (btn) {
    window.location.href = btn.data('redirect_url');
};

var completeMaterial = function(){
    var btn = $(this);
    $.ajax({
        type: 'POST',
        url : '/api/v1/courses/' + btn.data('course_id') + '/complete_material'
    }).success(function () {
        show_error('Материал пройден', 3000);
        setTimeout(function () {
            window.location.href = '/cabinet'
        }, 1500)
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

pageLoad(function () {
    $(document).on('click', '.js_downloadFile', function () {
        downloadAttachment($(this));
    });
    $(document).on('click', '.js_completeAttachment', function () {
       completeAttachment($(this));
    });
    $(document).on('click', '.js_completeMaterial', completeMaterial);
    $(document).on('click', '.js_redirectAttachment', function () {
        redirectAttachment($(this));
    });
});
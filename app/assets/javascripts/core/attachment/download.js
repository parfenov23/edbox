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
        setTimeout(function () {
            window.location.href = '/course_description?id=' + btn.data('course_id') + '&attachment_id=' + btn.data('id')
        }, 1500)
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

pageLoad(function () {
    $(document).on('click', '.js_downloadFile', function () {
        downloadAttachment($(this));
        //completeAttachment($(this));
    });
    $(document).on('click', '.js_completeAttachment', function () {
        completeAttachment($(this));
    });
});
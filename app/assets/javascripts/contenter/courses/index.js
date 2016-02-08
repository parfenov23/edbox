var removeCourseConteter = function(){
    var btn = $(this);
    var remove = function () {
        $.ajax({
            type: 'POST',
            url : '/api/v1/courses/' + btn.data("id") + '/remove'
        }).success(function (data) {
            btn.closest(".corses-prev").remove();
        }).error(function () {
            show_error('Произошла ошибка', 3000);
        });
    };
    confirm("Вы действительно хотите удалить курс?", remove);
};

pageLoad(function(){
    $(document).on('click', '.js_removeCourseConteter', removeCourseConteter)
});
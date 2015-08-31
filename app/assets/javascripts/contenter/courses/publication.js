var updateTypeCourse = function () {
    var btn = $(this);
    $.ajax({
        type: 'POST',
        url : '/api/v1/courses/' + btn.data('id') + '/update_type',
        data: {type: btn.data("type_id")}
    }).success(function (data) {
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
    return true;
};

var publicationCourse = function (){
    var btn = $(this);
    $.ajax({
        type: 'PUT',
        url : '/api/v1/courses/' + btn.data('id'),
        data: {course: {'public': btn.data('type')}}
    }).success(function (data) {
        if (btn.data('type')){
            show_error('Курс опубликован', 3000);
            btn.text("СНЯТЬ С ПУБЛИКАЦИИ");
        }else{
            show_error('Курс снят с публикации', 3000);
            btn.text("ОПУБЛИКОВАТЬ");
        }
        btn.data("type", !btn.data('type'));

    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
    return true;
};

pageLoad(function(){
    $(document).on('click', '#contenterPublication .js_updateTypeCourse', updateTypeCourse);
    $(document).on('click', '#contenterPublication .js_publicationCourse', publicationCourse);
    $(".connectedSortable").sortable({
        connectWith: ".connectedSortable",
        update: function( event, ui ) {
            console.log(123);
        }
    }).disableSelection();
});
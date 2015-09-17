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
        var rus_type = "Курс";
        if ($("#typeCourseInputVal").val() == "material"){
            var rus_type = "Материал";
        }
        if (btn.data('type')){
            show_error(rus_type + ' опубликован', 3000);
            btn.text("СНЯТЬ С ПУБЛИКАЦИИ");
        }else{
            show_error(rus_type + ' снят с публикации', 3000);
            btn.text("ОПУБЛИКОВАТЬ");
        }
        btn.data("type", !btn.data('type'));

    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
    return true;
};

var publicationCourseWebinar = function(){
    var btn = $(this);
    $.ajax({
        type: 'POST',
        url : '/api/v1/courses/' + btn.data('id') + "/public_webinar"
    }).success(function (data) {
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
    return true;
};
//public_webinar
pageLoad(function(){
    $(document).on('click', '#contenterPublication .js_updateTypeCourse', updateTypeCourse);
    $(document).on('click', '#contenterPublication .js_publicationCourse', publicationCourse);
    $(document).on('click', '#contenterPublication .js_publicationCourseWebinar', publicationCourseWebinar);
});
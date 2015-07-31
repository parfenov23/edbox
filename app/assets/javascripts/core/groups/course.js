var removeCourseToGroup = function (btn) {
    var course_id = btn.data("id");
    var group_id = btn.data("group_id");
    show_error('Загрузка', 3000);
    $.ajax({
        type: 'POST',
        url : '/api/v1/groups/' + group_id + '/remove_course',
        data: {course_id: course_id}
    }).success(function (data) {
        btn.closest("li.single-course").remove();
        show_error('Курс удален из группы', 3000);
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
    return true;
};

var changeDeadLineCourse = function (btn) {
    var group_id = btn.data("group_id");
    var data_time = btn.text();
    var course_id = btn.data("id");
    show_error('Загрузка', 3000);
    $.ajax({
        type: 'POST',
        url : '/api/v1/groups/' + group_id + '/update_course',
        data: {course_id: course_id, date_complete: data_time}
    }).success(function (data) {
        show_error('Дата оканчания курса изменена', 3000);
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

var changeDeadLineCourseMy = function (btn, text_success) {
    var data_time = btn.text();
    var course_id = btn.data("course_id");
    show_error('Загрузка', 3000);
    $.ajax({
        type: 'POST',
        url : '/api/v1/users/update_course',
        data: {course_id: course_id, date_complete: data_time}
    }).success(function () {
        if(btn.data("no_schedule") == true){
            location.reload();
        } else {
            show_error(text_success, 3000);
            loadMySchedule();
        }
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
    return true;
};

var removeCourseMy = function (btn, text_success) {
    var data_time = btn.text();
    var course_id = btn.data("course_id");
    show_error('Загрузка', 3000);
    $.ajax({
        type: 'POST',
        url : '/api/v1/users/remove_course',
        data: {course_id: course_id, date_complete: data_time}
    }).success(function () {
        show_error(text_success, 3000);
        btn.closest(".js__removeCourseMyBlock").remove();
        loadMySchedule();
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
    return true;
};

var changeDeadLineSectionMy = function (btn, text_success) {
    var data_time = btn.text();
    var section_id = btn.data("section_id");
    show_error('Загрузка', 3000);
    $.ajax({
        type: 'POST',
        url : '/api/v1/users/update_section',
        data: {section_id: section_id, date_complete: data_time}
    }).success(function () {
        if(btn.data("no_schedule") == true){
            location.reload();
        } else {
            show_error(text_success, 3000);
            loadMySchedule();
        }
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
    return true;
};

var bind_block = function () {
    $('.edit-menu .js_changeDeadLineCourseMy').bind('DOMNodeInserted DOMNodeRemoved DOMSubtreeModified', function () {
        changeDeadLineCourseMy($(this), $(this).data("text"));
    });
    $('.js__select-calendar').hover((function () {
        $(this).addClass('is__active');
        $('.js__backing').addClass('is__active');
    }), function () {
      if ($('#ui-datepicker-div').is(':hidden')) {
        console.log(12);
        $(this).removeClass('is__active');
      }

    });
    includeDatePicker();
};

var loadMySchedule = function (data) {
    $.ajax({
        type: 'POST',
        url : '/render_mini_schedule',
        data: data
    }).success(function (data) {
        $("#js-schedule-cabinet").html($(data).html());
        bind_block();
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

var selectMonthSchedule = function () {
    var btn = $(this);
    var number_month = btn.data("id");
    var common_select = btn.closest('.common_select');
    btn.closest('.listGroup').hide();
    loadMySchedule({schedule: {month: number_month} })
};

$(document).ready(function () {
    $("img:last").load(function () {
        $(document).on('click', '.hidden-list .js_removeCourseToGroup',
            function () {
                var btn = $(this);
                confirm("Вы действительно хотате удалить курс?",
                    function () {
                        removeCourseToGroup(btn)
                    }
                )
            });
        $(document).on('click', '.listGroup .selectMonthSchedule', selectMonthSchedule);
        $('.edit-menu .js_changeDeadLineCourse').bind('DOMNodeInserted DOMNodeRemoved DOMSubtreeModified', function () {
            changeDeadLineCourse($(this));
        });

        $('.edit-menu .js_changeDeadLineSectionMy').bind('DOMNodeInserted DOMNodeRemoved DOMSubtreeModified', function () {
            changeDeadLineSectionMy($(this));
        });

        $(document).on('click', '.js_removeCourseMy',
            function () {
                var btn = $(this);
                confirm("Вы действительно хотате удалить курс?",
                    function () {
                        removeCourseMy(btn, btn.data("text"));
                    }
                )
            });
        bind_block();
    });
});

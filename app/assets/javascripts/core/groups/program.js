var selectCourseProgram = function (btn) {
    window.location.href = "/group?id=" + btn.data("group_id") + "&type=schedule&course_id=" + btn.data("id");
};

pageLoad(function () {
    $(document).on('click', '.js_selectCourseProgram', function () {
        selectCourseProgram($(this));
    });
});
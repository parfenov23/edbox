var openPopup = function () {
    var btn = $(this);
    if(!btn.hasClass("noOpenPopup")){
        var popup = $("#js-add-course-to-shedule");
        var course_id = btn.data("id");
        popup.find("input.courseId").val(course_id);
        popup.show();
        popup.find(".check_group_added").show();
        popup.find(".end_added .description .courseFirstName").text($("#titleCoursePrev"+course_id).text())
    }else{
        show_error('У ваc нет групп', 3000);
    }
};

var openEdnPopup = function(){
    var popup = $("#js-add-course-to-shedule");
    popup.show();
    popup.find(".check_group_added").hide();
    popup.find(".end_added").addClass("allgood").show();
};

var closePopup = function (event) {
    var evt = evt || event;
    var target = evt.target || evt.srcElement;
    if ($(target).closest("#js-add-course-to-shedule").length == 0 || $(target).hasClass("cancel") > 0 || $(target).hasClass("add-course-to-shedule") > 0){
        var popup = $("#js-add-course-to-shedule");
        popup.hide();
        popup.find(".check_group_added").hide();
        popup.find(".end_added").hide();
        clearPopup();
    }
};

var clearPopup = function(){
    var popup = $("#js-add-course-to-shedule");
    var select = popup.find(".select");
    var calendar = popup.find(".calendar");
    select.find(".titleSelectGroup").text("Выберите группу");
    select.find(".selectGroupId").val("");
    calendar.removeClass("show");
    calendar.find(".datapicker__trigger").val("");
    popup.find(".courseId").val("");

};

var selectGroup = function () {
    var btn = $(this);
    var select = btn.closest(".select");
    select.find(".titleSelectGroup").text(btn.text());
    select.find(".selectGroupId").val(btn.data("id"));
    select.find(".listGroup").hide();
};

var addCourse = function(){
    var btn = $(this);
    var form = btn.closest("form");
    var data = form.serialize();
    $.ajax({
        type: 'POST',
        url : '/api/v1/groups/add_course',
        data: data
    }).success(function () {
        openEdnPopup();
        clearPopup();
        show_error('Курс добавлен в группу', 3000);
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
    return true;
};

$(document).ready(function () {
    $(document).on('click', '#js-favorite-courses .header .add-group, ' +
        '.courses-description .text-block .action-block .add-to-group', openPopup);
    $(document).on('click', '.corses-prev .action-btn .add', openPopup);
    $(document).on('click', '#js-add-course-to-shedule, #js-add-course-to-shedule .action-btn .btn.cancel', closePopup);
    $(document).on('click', '#js-add-course-to-shedule .listGroup .selectGroup', selectGroup);
    $(document).on('click', '#js-add-course-to-shedule .action-btn .btn.yes', addCourse);
});
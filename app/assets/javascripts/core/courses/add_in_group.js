var openPopup = function () {
    var btn = $(this);
    if (! btn.hasClass('noAddedMyCourse')){
        if (! btn.hasClass("noOpenPopup")){
            courseInfo(btn.data("id"));
            var popup = $("#js-add-course-to-shedule");
            var course_id = btn.data("id");
            popup.find("input.courseId").val(course_id);
            popup.show();
            popup.find(".check_group_added").show();
            popup.find(".end_added .description .courseFirstName").text($("#titleCoursePrev" + course_id).text());
            if (btn.data('hide') != undefined){
                popup.find(btn.data('hide')).hide();
            }
            if (btn.data('show') != undefined){
                popup.find(btn.data('show')).show();
            }
            popup.find(".js_addCourse").data("type", btn.data('type'))

        } else {
            show_error('У ваc нет групп', 3000);
        }
        $('.adaptive__title').each(function () {
            var rightWidth;
            rightWidth = $(this).find('.right-col').width();
            return $(this).find('.left-col').css({
                width: $(this).width() - rightWidth + 'px'
            });
        });
    } else {
        show_error('Нельзя добавить курс, так как курс добавленн в группу', 3000)
    }

};

var courseInfo = function (course_id) {
    $.ajax({
        type: 'get',
        url : '/api/v1/courses/' + course_id
    }).success(function (data) {
        var popup = $("#js-add-course-to-shedule");
        var block_selectSections = popup.find(".select-deadline.js_optionDatePicker").show();
        var blockCalendarCourse = popup.find(".calendar").show();
        var titleCourseType = popup.find(".titleCourseType").text("Добавить курс в ");
        blockCalendarCourse.find(".calendar-trigger")
            .text("Установите срок прохождения курса");
        if (data.type_course == "material"){
            titleCourseType.text("Добавить материал в ");
            block_selectSections.hide();
            blockCalendarCourse.find(".calendar-trigger")
                .text("Установите срок прохождения материала");

        }
        if (data.type_course == "online"){
            titleCourseType.text("Добавить вебинар в ");
            block_selectSections.hide();
            blockCalendarCourse.hide()
        }
        popup.find(".js__courseEditTitle span").text(data.title);
        $("ul.js_addTemplateSectionLi").html($(templateLiSection(data)));
        includeDatePicker();
        $('.adaptive__title').each(function () {
            var rightWidth;
            rightWidth = $(this).find('.right-col').width();
            return $(this).find('.left-col').css({
                width: $(this).width() - rightWidth + 'px'
            });
        });
        $("#js-add-course-to-shedule .section-item .js_changeDateToDatePicker").change(changeTextSelectSections);

    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
    return true;
};

var templateLiSection = function (json_course) {
    var html = [];
    $.each(json_course.sections, function (i, obj) {
        html[i] =
            '<li class="section-item adaptive__title">' +
            '<div class="left-part left-col">' +
            obj.title +
            '</div>' +
            '<div class="right-part right-col">' +
            '<div class="date-added">' +
            '</div>' +
            '<div class="set-date">' +
            '<i class="icon"></i>' +
            '<input class="datapicker__trigger js__set-date js_changeDateToDatePicker childDatePickerTime" name="sections[' + obj.id + ']"/>' +
            '</div>' +
            '</div>' +
            '</li>';
    });

    return html.join('');
};

var openEdnPopup = function () {
    var popup = $("#js-add-course-to-shedule");
    popup.show();
    popup.find(".check_group_added").hide();
    popup.find(".end_added").addClass("allgood").show();
};

var closePopup = function (event) {
    //var evt = evt || event;
    //var target = evt.target || evt.srcElement;
    //if ($(target).closest("#js-add-course-to-shedule").length == 0 || $(target).hasClass("cancel") > 0 || $(target).hasClass("add-course-to-shedule") > 0){
    var popup = $("#js-add-course-to-shedule");
    popup.hide();
    popup.find(".check_group_added").hide();
    popup.find(".end_added").hide();
    clearPopup();
    //}
};

var clearPopup = function () {
    var popup = $("#js-add-course-to-shedule");
    var select = popup.find(".select");
    var calendar = popup.find(".calendar");
    calendar.removeClass("show");
    //select.find(".titleSelectGroup").text("Выберите группу");
    //select.find(".selectGroupId").val("");

    calendar.find(".datapicker__trigger").val("");
    popup.find(".courseId").val("");
    installTitleFormPopup(0);
};

var selectGroup = function () {
    var btn = $(this);
    var select = btn.closest(".select");
    select.find(".titleSelectGroup").text(btn.text());
    select.find(".selectGroupId").val(btn.data("id"));
    select.find(".listGroup").hide();
};

var addCourse = function () {
    var btn = $(this);
    if (btn.data("type") == "group"){
        addCourseGroup(btn);
    }
    if (btn.data("type") == "user"){
        addCourseMySchedule(btn);
    }
};

var addCourseGroup = function (btn) {
    var form = btn.closest("form");
    var data = form.serialize();
    $.ajax({
        type: 'POST',
        url : '/api/v1/groups/add_course',
        data: data
    }).success(function (data) {
        if (data.error == undefined){
            var group_id = form.find(".selectGroupId").val();
            $("#js-add-course-to-shedule .end_added .action-btn .btn.yes.js_goToSchedule").attr("onclick", "window.location.href='/group/" + group_id);
            openEdnPopup();
            clearPopup();
            var id_course = form.find("input.courseId").val();
            $("#titleCoursePrev" + id_course).closest("a").removeClass(".js_goToAttachmentLock");
            show_error('Курс добавлен в группу', 3000);
        }else{
            show_error(data.error, 3000);
        }
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
    return true;
};

var addCourseMySchedule = function () {
    var btn = $(this);
    var form = btn.closest("form");
    var data = form.serialize();
    $.ajax({
        type: 'POST',
        url : '/api/v1/users/update_course',
        data: data
    }).success(function () {
        var time_redirect = 0;
        if (form.data('alert') != false){
            time_redirect = 1500;
            show_error('Курс добавлен в мои курсы', 3000);
        }
        setTimeout(function(){
            if(form.data('redirect') != undefined && !btn.hasClass('js_eventUnRegUser') && !btn.hasClass('js_eventRegUser')){
                window.location.href = form.data('redirect');
            }
        }, time_redirect);
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
    return true;
};

var changeDateToDatePicker = function (input) {
    input.closest(".section-item").find(".date-added").text(input.val());
};

var changeTextSelectSections = function () {
    var select_not_empty = $(this).closest(".section-list").find("input").filter(function () {
        return this.value;
    });
    var count = select_not_empty.length;
    installTitleFormPopup(count)
};

var installTitleFormPopup = function (count) {
    var form = $("#js-add-course-to-shedule");
    var count_all_inputs = form.find(".section-list input").length;
    var selected_title = form.find(".select-deadline .select_date_time");
    var not_selected_title = form.find(".select-deadline .not_select_date_time");

    if (count){
        not_selected_title.hide();
        selected_title.show();
        selected_title.find(".count_select").show();
        if (count == 1){
            selected_title.find(".title .count_select").text(" " + count + " раздела");
        } else {
            if (count < count_all_inputs){
                selected_title.find(".title .count_select").text(" " + count + " разделов");
            } else {
                selected_title.find(".title .count_select").text(" всех разделов");
            }
        }
    } else {
        not_selected_title.show();
        selected_title.hide();
    }
};

var optionDatePickerCourse = function (btn) {
    var form = btn.closest("form");
    var date_picker = form.find(".parentDatePickerTime");
    var child_date_picker = form.find(".childDatePickerTime");
    if (date_picker.val().length){
        $.each(child_date_picker, function (n, el) {
            $(el).data(date_picker.data('type'), parseDate(date_picker.val()));
        });
    }
};

var closeSelectDeadLineSections = function () {
    $(this).closest("form").find(".action-btn").show();
    $(this).closest("form").find(".action-btn.actionSectionDeadLine").hide();
    return $(this).closest('.check_group_added').removeClass('section__deadline');
};

var goToAttachmentLock = function (event) {
    event.preventDefault();
    show_error("Добавьте материал в расписание!", 3000)
};
var goToAttachment = function(){
    var btn = $(this);
    window.location.href = "/attachment?id="+btn.attr('data-id');
};
$(document).ready(function () {
    $(document).on('click', '#js-favorite-courses .header .add-group, ' +
        '.courses-description .text-block .action-block .add-to-group', openPopup);
    $(document).on('click', '.corses-prev .action-btn .js_openPopup', openPopup);
    $(document).on('click', '.main__action .js_openPopup', openPopup); // course description
    $(document).on('click', '#js-add-course-to-shedule .action-btn .btn.cancel', closePopup);
    $(document).on('click', '#js-add-course-to-shedule .listGroup .selectGroup', selectGroup);
    $(document).on('click', '#js-add-course-to-shedule form .action-btn.sendAction .btn.yes.js_addCourse', addCourse);
    $(document).on('click', '#js-add-course-to-shedule form .js_optionDatePicker', function () {optionDatePickerCourse($(this))});
    $(document).on('click', ".section__deadline-title .back, .section__deadline .actionSectionDeadLine .yes", closeSelectDeadLineSections)
    $(document).on('click', ".js_goToAttachmentLock", goToAttachmentLock);
    $(document).on('click', ".js_addCourseToMyCourse", addCourseMySchedule);
    $(document).on('click', ".js_goToAttachment", goToAttachment)
});

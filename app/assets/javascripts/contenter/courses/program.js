var createCourseContenterProgram = function (action) {
    $.ajax({
        type: 'POST',
        url : '/api/v1/courses/',
        data: {}
    }).success(function (data) {
        var input_id = formInputIdCourse();
        input_id.val(data.id);
        $("#contenterCourseProgram .js_createSectionToSection").data("course_id", data.id);
        history.pushState({}, '', "/contenter/courses/" + data.id + "/program");
        action()
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
    return true;
};

var openInputFile = function (id, accept) {
    var element = $("input#" + id);
    element.attr("accept", accept);
    element[0].click();
};

var setAttachmentType = function () {
    var btn = $(this);
    $.ajax({
        type: 'POST',
        url : '/api/v1/attachments/' + btn.data("id") + "/set_type",
        data: {type: btn.data("type")}
    }).success(function (data) {
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
    return true;
};

var ajaxUpdateSection = function (type, btn) {
    var form = btn.closest("form");
    $.ajax({
        type: 'PUT',
        url : '/api/v1/' + type + '/' + form.data("id"),
        processData: false,
        contentType: false,
        cache      : false,
        data: form.serializefiles()
    }).success(function (data) {
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

var onChangeEditSection = function () {
    ajaxUpdateSection('sections', $(this));
};

var onChangeEditAttachment = function () {
    var input = $(this);
    var block_info = input.closest(".attachment.item").find(".info_attachment");
    var form = input.closest("form")
    var input_file = form.find("input[name='attachment[file]']");

    if (input.attr("name") == "attachment[title]"){
        block_info.find(".title").text(input.val());
        input_file.attr("name", "");
    }
    if (input.attr("name") == "attachment[description]"){
        block_info.find(".description").text(input.val());
        input_file.attr("name", "");
    }
    ajaxUpdateSection('attachments', input);
    input_file.attr("name", "attachment[file]");
};

var createAttachmentToSection = function () {
    var btn = $(this);
    var data = {attachmentable_type: "Section", attachmentable_id: btn.data("section_id")};
    $.ajax({
        type: 'POST',
        url : '/api/v1/attachments',
        data: data
    }).success(function (data) {
        loadHtmlAttachmentToSection(data.id, btn);
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

var loadHtmlAttachmentToSection = function (id, btn) {
    $.ajax({
        type: 'POST',
        url : '/api/v1/attachments/' + id + '/attachment_contenter_html',
        data: {class_state: "open"}
    }).success(function (data) {
        var html = $(data);
        btn.closest(".descriptionSection").find(".allAttachmentsSection").append(html);
        loadBindOnChangeInput();
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

var createSectionToSection = function () {
    var btn = $(this);
    var ajax_action = function () {
        $.ajax({
            type: 'POST',
            url : '/api/v1/sections',
            data: {section: {course_id: btn.data("course_id")}}
        }).success(function (data) {
            loadHtmlSectionToSection(data.id, btn);
        }).error(function () {
            show_error('Произошла ошибка', 3000);
        });
    };
    if (btn.data("course_id") != undefined){
        ajax_action()
    } else {
        createCourseContenterProgram(ajax_action)
    }
};

var loadHtmlSectionToSection = function (id, btn) {
    $.ajax({
        type: 'POST',
        url : '/api/v1/sections/' + id + '/contenter_html'
    }).success(function (data) {
        var html = $(data);
        btn.closest(".js_parentClosestSection").find(".allSectionsProgram").append(html);
        loadBindOnChangeInput();
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

var removeAttachmentToSection = function () {
    var btn = $(this);
    var remove = function () {
        $.ajax({
            type: 'POST',
            url : '/api/v1/attachments/' + btn.data("id") + '/remove'
        }).success(function (data) {
            btn.closest(".attachment.item").remove();
        }).error(function () {
            show_error('Произошла ошибка', 3000);
        });
    };
    confirm("Вы действительно хотите удалить материал?", remove);
};

var removeSectionToCourse = function () {
    var btn = $(this);
    var remove = function () {
        $.ajax({
            type: 'POST',
            url : '/api/v1/sections/' + btn.data("id") + '/remove'
        }).success(function (data) {
            btn.closest(".section").remove();
        }).error(function () {
            show_error('Произошла ошибка', 3000);
        });
    };
    confirm("Вы действительно хотите удалить секцию?", remove);
};

var loadBindOnChangeInput = function () {
    $('#contenterCourseProgram .js_onChangeEditSection').change(onChangeEditSection);
    $('#contenterCourseProgram .js_onChangeEditAttachment').change(onChangeEditAttachment);
    $('#contenterCourseProgram .uploadFileInput').change(onChangeEditAttachment);
};

var selectAttachment = function(){
    var btn = $(this);
    btn.closest(".upload_attachments").find(".selectAttachment").removeClass("active");
    btn.addClass("active");
};

//var uploadFileInput = function(){
//    console.log(123);
//};

pageLoad(function () {
    loadBindOnChangeInput();
    $(document).on("click", "#contenterCourseProgram .js_createAttachmentToSection", createAttachmentToSection);
    $(document).on("click", "#contenterCourseProgram .js_removeAttachmentToSection", removeAttachmentToSection);
    $(document).on("click", "#contenterCourseProgram .js_createSectionToSection", createSectionToSection);
    $(document).on("click", "#contenterCourseProgram .js_removeSectionToCourse", removeSectionToCourse);
    $(document).on("click", "#contenterCourseProgram .js_setAttachmentType", setAttachmentType);
    $(document).on("click", "#contenterCourseProgram .selectAttachment", selectAttachment);
});
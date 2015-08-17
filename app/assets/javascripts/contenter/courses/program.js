function init_tiny() {
    tinymce.init({
        selector: "textarea.js_includeTiny",
        height  : 300,
        menu    : { // this is the complete default configuration
            //edit   : {title : 'Редактирование'  , items : 'undo redo | cut copy paste pastetext | selectall'},
            insert: {title: 'Insert', items: 'link media | template hr'},
            //format : {title : 'Форматирование', items : 'bold italic underline strikethrough superscript subscript | formats | removeformat'},
            table : {title: 'Table', items: 'inserttable tableprops deletetable | cell row column'},
            tools : {title: 'Tools', items: 'spellchecker code'}
        },
        setup   : function (editor) {
            editor.on('change', function (e) {
                var editor_tiny = $(e.target.editorContainer);
                var form = editor_tiny.closest("form");
                var textarea = form.find("textarea[name='attachment[full_text]']");
                textarea.val(e.target.getBody().innerHTML);
                onChangeEditAttachment(editor_tiny);
            });
        }
    });
}

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
    if (btn.data("type") != "download"){
        openEditFileAfterUpload(btn);
    }
    return true;
};

var openEditFileAfterUpload = function (btn) {
    var type = btn.data("type");
    var form = btn.closest("form.form_edit");
    var block_show = form.find(".editFileUpload .itemFile[data-type='" + type + "']")
    btn.closest(".upload_attachments").hide();
    block_show.show();
    return block_show;
};

var ajaxUpdateSection = function (type, btn) {
    var form = btn.closest("form");
    $.ajax({
        type       : 'PUT',
        url        : '/api/v1/' + type + '/' + form.data("id"),
        processData: false,
        contentType: false,
        cache      : false,
        data       : form.serializefiles()
    }).success(function (data) {
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

var ajaxUploadFileAttachment = function (file) {
    var form = file.closest("form");
    var formdata = new FormData();
    file = file[0].files[0];
    formdata.append("attachment[file]", file);
    var xhr = new XMLHttpRequest();
    xhr.upload.addEventListener("progress", uploadProgress, false);
    xhr.addEventListener("load", function(e) {
        uploadComplete(e, form);
    }, false);
    xhr.addEventListener("error", uploadFailed, false);
    xhr.addEventListener("abort", uploadCanceled, false);

    xhr.open('PUT', '/api/v1/attachments/' + form.data("id"), true);
    xhr.send(formdata);
};

function uploadProgress(evt) {
    if (evt.lengthComputable){
        console.log(evt);
        var percentComplete = Math.round(evt.loaded * 100 / evt.total);
        show_error('Загрузка: ' + percentComplete.toString() + '%', 3000);
    }
    else {
        console.log('unable to compute');
    }
}

function uploadComplete(evt, form) {
    var input_file = form.find("input[name='attachment[file]']");
    var block_fileInfo = openEditFileAfterUpload(input_file);
    show_error('Згруженно!', 3000);
}

function uploadFailed(evt) {
    show_error('Произошла ошибка', 3000);
}

function uploadCanceled(evt) {
    console.log("The upload has been canceled by the user or the browser dropped the connection.");
}

var onChangeEditSection = function () {
    ajaxUpdateSection('sections', $(this));
};

var onChangeEditAttachment = function (input_incl) {
    var input;
    if (input_incl.type == "change"){
        input = $(this);
    } else {
        input = input_incl
    }
    ;
    var block_info = input.closest(".attachment.item").find(".info_attachment");
    var form = input.closest("form");
    var input_file = form.find("input[name='attachment[file]']");

    if (input.attr("name") == "attachment[title]"){
        block_info.find(".title").text(input.val());
        input_file.attr("name", "");
    }
    if (input.attr("name") == "attachment[description]"){
        block_info.find(".description").text(input.val());
        input_file.attr("name", "");
    }
    if (input.attr("name") == "attachment[full_text]"){
        input_file.attr("name", "");
    }

    if (input.attr("name") == "attachment[file]"){
        ajaxUploadFileAttachment(input);
    } else {
        ajaxUpdateSection('attachments', input);
        input_file.attr("name", "attachment[file]");
    }
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

var selectAttachment = function () {
    var btn = $(this);
    btn.closest(".upload_attachments").find(".selectAttachment").removeClass("active");
    btn.addClass("active");
};

//var uploadFileInput = function(){
//    console.log(123);
//};

pageLoad(function () {
    init_tiny();
    loadBindOnChangeInput();
    $(document).on("click", "#contenterCourseProgram .js_createAttachmentToSection", createAttachmentToSection);
    $(document).on("click", "#contenterCourseProgram .js_removeAttachmentToSection", removeAttachmentToSection);
    $(document).on("click", "#contenterCourseProgram .js_createSectionToSection", createSectionToSection);
    $(document).on("click", "#contenterCourseProgram .js_removeSectionToCourse", removeSectionToCourse);
    $(document).on("click", "#contenterCourseProgram .js_setAttachmentType", setAttachmentType);
    $(document).on("click", "#contenterCourseProgram .selectAttachment", selectAttachment);
});
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
        var header = $("#page__header .page__children");
        header.find(".contenter_courses_edit").attr('href', '/contenter/courses/' + data.id + '/edit');
        header.find(".contenter_courses_programm").attr('href', '/contenter/courses/' + data.id + '/program');
        header.find(".contenter_courses_public").attr('href', '/contenter/courses/' + data.id + '/publication');
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
    var block_show = form.find(".editFileUpload .itemFile[data-type='" + type + "']");
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
    xhr.addEventListener("load", function (e) {
        uploadComplete(e, form);
    }, false);
    xhr.addEventListener("error", uploadFailed, false);
    xhr.addEventListener("abort", uploadCanceled, false);

    xhr.open('PUT', '/api/v1/attachments/' + form.data("id"), true);
    xhr.send(formdata);
};

function uploadProgress(evt) {
    if (evt.lengthComputable){
        var percentComplete = Math.round(evt.loaded * 100 / evt.total);
        show_error('Загрузка: ' + percentComplete.toString() + '%', 3000);
    }
    else {
        console.log('unable to compute');
    }
}

function uploadComplete(evt, form) {
    var input_file = form.find("input[name='attachment[file]']");
    var response = JSON.parse(evt.target.response);
    var block_fileInfo = openEditFileAfterUpload(input_file);
    block_fileInfo.find(".fileInfo .titleName").text(response.file_name);
    block_fileInfo.find(".fileInfo .fileType .icon").attr("class", "icon content");
    block_fileInfo.find(".fileInfo .fileType .icon").addClass(response.file_type);
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
        show_error('Идет загрузка файла', 3000);
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

var selectAttachment = function () {
    var btn = $(this);
    btn.closest(".upload_attachments").find(".selectAttachment").removeClass("active");
    btn.addClass("active");
};

var createAttachmentTest = function () {
    var btn = $(this);
    $.ajax({
        type: 'POST',
        url : '/api/v1/tests',
        data: {test: {testable_id: btn.data("id"), testable_type: "Attachment"}, type: "html"}
    }).success(function (data) {
        btn.closest("form").find(".editFileUpload .addedTest").append($(data));
        loadBindOnChangeInput();
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

var createQuestionToTest = function () {
    var btn = $(this);
    $.ajax({
        type: 'POST',
        url : '/api/v1/questions',
        data: {question: {test_id: btn.data("id")}, type: "html"}
    }).success(function (data) {
        btn.closest(".addedTest").find(".testHolder").append($(data));
        loadBindOnChangeInput();
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

var changeQuestionInput = function () {
    var btn = $(this);
    var form = btn.closest("form");
    $.ajax({
        type: 'PUT',
        url : '/api/v1/questions/' + btn.closest(".currentQuestionId").data("id"),
        data: btn.closest("form").serialize()
    }).success(function (data) {
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};
var setTimeoutChangeAnswer;
var changeAnswerInput = function () {
    var btn = $(this);
    clearTimeout(setTimeoutChangeAnswer);
    setTimeoutChangeAnswer = setTimeout(function () {
        var form = btn.closest("form");
        var checked_input = btn.closest(".questionItem").find(".auth_agree input.checkbox");
        var checked = false;
        if (checked_input.attr("checked") == "checked"){
            checked = true;
        }
        $.ajax({
            type: 'PUT',
            url : '/api/v1/answers/' + btn.data("id"),
            data: {answer: {text: btn.val(), right: checked}}
        }).success(function (data) {
        }).error(function () {
            show_error('Произошла ошибка', 3000);
        });
    }, 300);


};

var getCloneQuestion = function (input) {
    var parentBlock = input.closest(".questionItem");
    var next_block = parentBlock.next();
    if (next_block.length){
        SetCaretAtEnd(next_block.find(".questionInput")[0])
    } else {
        createAnswerToQuestion(parentBlock);
    }
};

var createAnswerToQuestion = function (parentBlock) {
    $.ajax({
        type: 'POST',
        url : '/api/v1/answers',
        data: {answer: {question_id: parentBlock.closest(".currentQuestionId").data("id")}, type: "html"}
    }).success(function (data) {
        parentBlock.closest(".questions").append($(data));
        var input = parentBlock.closest(".questions").find(".questionItem .questionInput:last");
        SetCaretAtEnd(input[0]);
        input.focus();
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

var removeQuestionToTest = function () {
    var btn = $(this);
    confirm("Вы действительно хотите удалить ответ на вопрос?", function () {
        btn.closest('.attachment.item').removeClass("closed-state").addClass("open-state");
        $.ajax({
            type: 'POST',
            url : '/api/v1/questions/' + btn.data("id") + '/remove'
        }).success(function (data) {
            btn.closest(".testIssue").remove();
        }).error(function () {
            show_error('Произошла ошибка', 3000);
        });
    });

};

var removeAnswerToQuestion = function (input) {
    if (! input.val().length){
        var block = input.closest(".questionItem");
        var prev_block = block.prev();
        var blocks = block.closest(".questions").find(".questionItem");
        if (blocks.length > 2){
            $.ajax({
                type: 'POST',
                url : '/api/v1/answers/' + input.data("id") + "/remove"
            }).success(function (data) {
                block.remove();
                SetCaretAtEnd(prev_block.find(".questionInput")[0]);
            }).error(function () {
                show_error('Произошла ошибка', 3000);
            });
        } else {
            SetCaretAtEnd(prev_block.find(".questionInput")[0]);
        }
    }
};

var addTestToCourse = function () {
    var btn = $(this);
    $.ajax({
        type: 'POST',
        url : '/api/v1/tests',
        data: {test: {testable_id: btn.data("id"), testable_type: "Course"}, type: "html", file_name: "_final_test"}
    }).success(function (data) {
        $("#finalTestCourse").append($(data));
        btn.hide();
        $("#finalTestCourse").removeClass("closed-state").addClass("open-state");
        loadBindOnChangeInput();
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

var loadBindOnChangeInput = function () {
    $('#contenterCourseProgram .js_onChangeEditSection').change(onChangeEditSection);
    $('#contenterCourseProgram .js_onChangeEditAttachment').change(onChangeEditAttachment);
    $('#contenterCourseProgram .uploadFileInput').change(onChangeEditAttachment);
    $('#contenterCourseProgram .js_changeQuestionInput').change(changeQuestionInput);
    $('#contenterCourseProgram .js_changeAnswerInput').change(changeAnswerInput);
    removeExtraElement();
    try{
        init_tiny();
    }
    catch (err){
    }

};

var removeExtraElement = function () {
    $.each($(".questions"), function (n, el) {
        $.each($(el).find(".questionItem"), function (num, el) {
            if (num <= 1){
                $(el).find(".remove.js_removeAnswerToQuestion").remove();
            }
        })
    })
};

var removeTestToCourse = function () {
    var btn = $(this);
    confirm("Вы действительно хотите удалить финальный тест?", function () {
        $.ajax({
            type: 'POST',
            url : '/api/v1/tests/' + btn.data("id") + "/remove"
        }).success(function (data) {
            $(".section.add_new.js_addTestToCourse").removeClass("hideBtnFinalTest").show();
            $("#finalTestCourse .parentFinalTest").remove();
        }).error(function () {
            show_error('Произошла ошибка', 3000);
        });
    });
};


$(document).ready(function () {
    loadBindOnChangeInput();
    bindEventDocument({
        nameAction: 'click', parentBlock: '#contenterCourseProgram',
        arrElem   : [
            ".js_createAttachmentToSection",
            ".js_removeAttachmentToSection",
            ".js_createSectionToSection",
            ".js_removeQuestionToTest",
            ".js_removeSectionToCourse",
            ".js_setAttachmentType",
            ".selectAttachment",
            ".js_createAttachmentTest",
            ".js_changeAnswerInput",
            ".js_addTestToCourse",
            ".js_removeTestToCourse",
            ".js_createQuestionToTest"
        ]
    });

    $(document).on("click", "#contenterCourseProgram .js_removeAnswerToQuestion", function () {
        var btn = $(this);
        var input = btn.closest(".questionItem").find(".questionInput");
        confirm("Вы действительно хотите удалить ответ на вопрос?", function () {
            input.val('');
            input.closest('.attachment.item').removeClass("closed-state").addClass("open-state");
            removeAnswerToQuestion(input);
        });

    });

    $(document).on('keyup paste input propertychange', '#contenterCourseProgram .js_changeAnswerInput', changeAnswerInput);
    $(document).on("keydown", "#contenterCourseProgram .js_getCloneQuestion", function (evt) {
        var keycode = (evt.keyCode?evt.keyCode:evt.which);
        if (keycode == '13'){
            getCloneQuestion($(this))
        }
        if (keycode == 8){
            removeAnswerToQuestion($(this));
        }
    });
    removeExtraElement();
});
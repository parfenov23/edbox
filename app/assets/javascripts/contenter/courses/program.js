var createCourseContenterProgram = function (action, new_create) {
    var type_course = $("#typeCourseInputVal").val();
    $.ajax({
        type: 'POST',
        url : '/api/v1/courses/',
        data: {course: {type_course: type_course}}
    }).success(function (data) {
        var input_id = formInputIdCourse();
        input_id.val(data.id);
        $("#contenterCourseProgram .js_createSectionToSection").data("course_id", data.id);

        var type_link = "courses";
        if (type_course == "material"){
            type_link = "materials";
        }
        if (type_course == "material"){
            if (new_create == "new_attachment"){
                $('form.form_edit').data('id', data.id);
                $('form.form_edit').attr('data-id', data.id);
                $(".upload_attachments input[name='attachment[attachmentable_id]']").val(data.id);
                onChangeEditAttachment($(".upload_attachments input[name='attachment[attachmentable_type]']"));
            }
        }
        history.pushState({}, '', "/contenter/" + type_link + "/" + data.id + "/edit");
        var header = $("#page__header .page__children");
        header.find(".contenter_courses_edit").attr('href', '/contenter/' + type_link + '/' + data.id + '/edit');
        header.find(".contenter_courses_programm").attr('href', '/contenter/' + type_link + '/' + data.id + '/program');
        header.find(".contenter_courses_public").attr('href', '/contenter/' + type_link + '/' + data.id + '/publication');
        setTimeout(function () {
            action()
        }, 100);

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
    var sendAjax = function () {
        var includeSetInterval = setInterval(function () {
            if (btn.attr('data-id') != "new"){
                $.ajax({
                    type: 'POST',
                    url : '/api/v1/attachments/' + btn.attr('data-id') + "/set_type",
                    data: {type: btn.data("type")}
                }).success(function (data) {
                }).error(function () {
                    show_error('Произошла ошибка', 3000);
                });
                if (btn.data("type") != "download"){
                    openEditFileAfterUpload(btn);
                }
                clearInterval(includeSetInterval);
                return true;
            }
        }, 50);
    };
    if (btn.data('id') == "new"){
        var type_course = $("#typeCourseInputVal").val();
        if (type_course == "material"){
            if (formInputIdCourse().val() == "new"){
                createCourseContenterProgram(sendAjax, "new_attachment"); // materials!!!!!!!!!!!! ==============
            } else {
                onChangeEditAttachment($(".upload_attachments input[name='attachment[attachmentable_type]']"));
                sendAjax();

            }
        } else {
            createCourseContenterProgram(sendAjax);
        }
    } else {
        sendAjax();
    }

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
    var id_form = form.data("id");
    $.ajax({
        type       : 'PUT',
        url        : '/api/v1/' + type + '/' + id_form,
        processData: false,
        contentType: false,
        cache      : false,
        data       : form.serializefiles()
    }).success(function (data) {
        if (type == "attachments"){
            $(".upload_attachments .js_setAttachmentType").attr("data-id", data.id).data("id", data.id);
            $("form.form_edit").data("id", data.id);
        }
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

var ajaxUploadFileAttachment = function (file) {
    var form = file.closest("form");
    var formdata = new FormData();
    var uploadFile = function () {
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

    uploadFile()

};

function uploadProgress(evt) {
    if (evt.lengthComputable){
        var percentComplete = Math.round(evt.loaded * 100 / evt.total);
        show_error('Загрузка: ' + percentComplete.toString() + '%', 0);
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
    show_error('Загружено!', 3000);
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
    if (input.attr("name") == "attachment[full_text]" || input.attr("name") == "attachment[duration]"){
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
    var data = {attachmentable_type: "Section", attachmentable_id: btn.data("section_id"), file_type: btn.data('file_type')};
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
            allValidateForms();
            updatePositionAttachment();
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
            allValidateForms();
            updatePositionAttachment();
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
    validateTestQuestion();
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
        validateTestQuestion();
        var form = btn.closest("form");
        var input = btn.closest(".questionItem").find(".questionInput");
        var checked_input = btn.closest(".questionItem").find(".auth_agree input.checkbox");
        var checked = false;
        if (checked_input.attr("checked") == "checked"){
            checked = true;
        }
        $.ajax({
            type: 'PUT',
            url : '/api/v1/answers/' + btn.data("id"),
            data: {answer: {text: input.val(), right: checked}}
        }).success(function (data) {
        }).error(function () {
            show_error('Произошла ошибка', 3000);
        });
    }, 150);


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
            allValidateForms();
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
                allValidateForms();
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
        $("#finalTestCourse").show();
        $("#finalTestCourse").append($(data));
        btn.hide();
        $("#finalTestCourse").removeClass("closed-state").addClass("open-state");
        loadBindOnChangeInput();
        allValidateForms();
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

var onChangeDateTimeWebinar = function () {
    var input = $(this);
    var prent_block = input.closest(".times");
    var parent_input = prent_block.find(".webinarDateStart");
    var date_time = prent_block.find("input[data-type='date_time']").val();
    var date_hour = prent_block.find("input[data-type='hour']").val();
    var date_min = prent_block.find("input[data-type='min']").val();
    if (! date_hour.length){
        date_hour = 0
    }
    if (! date_min.length){
        date_min = 0
    }
    var time = date_time + " " + parseInt(date_hour) + ":" + parseInt(date_min);

    if (date_hour <= 23 && date_min <= 59){
        parent_input.val(time);
        updateWebinarInAttachment(parent_input)
    } else {
        show_error('Проверьте дату', 3000);
    }
};

var updateWebinarInAttachment = function (btn) {
    if ($(btn.target).length){
        btn = $(btn.target);
    }
    var form_webinar = btn.closest(".formWebinar");
    $.ajax({
        type: 'PUT',
        url : '/api/v1/webinars/' + form_webinar.data("id"),
        data: form_webinar.closest("form").serialize()
    }).success(function (data) {

    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

var loadBindOnChangeInput = function () {
    $('#contenterCourseProgram .js_onChangeEditSection').change(onChangeEditSection);
    $('#contenterCourseProgram .js_onChangeEditAttachment, #materialEditContenter .js_onChangeEditAttachment').change(onChangeEditAttachment);
    $('#contenterCourseProgram .uploadFileInput, #materialEditContenter .uploadFileInput').change(onChangeEditAttachment);
    $('#contenterCourseProgram .js_changeQuestionInput').change(changeQuestionInput);
    $('#contenterCourseProgram .js_changeAnswerInput').change(changeAnswerInput);
    $('#contenterCourseProgram .js_onChangeDateTimeWebinar').change(onChangeDateTimeWebinar);
    $('#contenterCourseProgram .js_updateWebinarInAttachment').change(updateWebinarInAttachment);

    removeExtraElement();
    try{
        init_tiny();
    }
    catch (err){
    }
    sortableSections();

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
            $("#finalTestCourse").hide();
            allValidateForms();
        }).error(function () {
            show_error('Произошла ошибка', 3000);
        });
    });
};

var attachmentNameValidate = function () {
    var input = $(this);
    var max_length = input.data('max_length');
    input.closest(".form_group").find(".validateMaxCount .current_count").text(input.count_text_input())
    if (input.count_text_input() > max_length && input.data('valid')){
        input.closest(".form_group").addClass("error");
        input.val(input.val().substr(0, max_length));
    } else {
        input.closest(".form_group").removeClass("error");
    }
};

var updatePositionAttachment = function () {
    var data_hash = {ids_sections: [], ids_attachments: []};
    var sections = $(".allAttachmentsSection.connectedSortable");
    $.each(sections, function () {
        var section = $(this);
        data_hash.ids_sections[data_hash.ids_sections.length] = section.data('id');
        var attachments = section.find(".attachment.item");
        var arr_attachments = [];
        $.each(attachments, function () {
            var attachment = $(this);
            arr_attachments[arr_attachments.length] = attachment.data('id');
        });
        data_hash.ids_attachments[data_hash.ids_attachments.length] = arr_attachments;
    });
    $.ajax({
        type: 'POST',
        url : '/api/v1/attachments/update_positions',
        data: data_hash
    }).success(function (data) {
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

var openInfoParent = function () {
    $(this).closest(".attachment.item").addClass("open-state").removeClass("closed-state")
};

var sortableSections = function () {
    $(".connectedSortable").sortable({
        connectWith: ".connectedSortable",
        update     : function (event, ui) {
            updatePositionAttachment();
            allValidateForms();
            //console.log($(ui.item) );
        }
    }).disableSelection();
};

var loadIdsLeadsWebinar = function () {
    var btn = $(this);
    var rightBar = $("#js-leading-online-courses");
    rightBar.data("id", btn.data("webinar_id"));
    $.ajax({
        type: 'POST',
        url : '/api/v1/webinars/' + btn.data('webinar_id') + "/all_leading"
    }).success(function (data) {
        rightBar.find(".leading__list .item").removeClass("active");
        $.each(data, function (n, id) {
            rightBar.find(".leading__list .item[data-id='" + id + "']").addClass("active");
        });
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

var addLeadingToWebinar = function () {
    var btn = $(this);
    var parent = btn.closest("#js-leading-online-courses");
    if (! btn.hasClass("active")){
        btn.addClass("active");
        $.ajax({
            type: 'POST',
            url : '/api/v1/webinars/' + parent.data('id') + "/add_leading",
            data: {user_id: btn.data("id"), type: "html"}
        }).success(function (data) {
            $(".allLeadsWebinarAttachment" + parent.data('id')).append($(data));
        }).error(function () {
            show_error('Произошла ошибка', 3000);
        });
    }
};

var removeLeadingToWebinar = function (btn) {
    $("#js-leading-online-courses").removeClass("show");
    $.ajax({
        type: 'POST',
        url : '/api/v1/webinars/' + btn.data('webinar_id') + "/remove_leading",
        data: {user_id: btn.data("id")}
    }).success(function (data) {
        btn.closest(".blockLead").remove();
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

var openFormUploadTeaser = function () {
    var openFormWindow = function () {
        $(".upload_teaser_material input").click();
    };

    if (formInputIdCourse().val() == "new"){
        createCourseContenterProgram(function(){});
        setTimeout(function(){
            openFormWindow();
        }, 300);

    }else{
        openFormWindow();
    }
};

var updateMaterialTeaser = function () {
    var btn = $(this);
    var form = btn.closest("form");
    var input_id = formInputIdCourse();
    $.ajax({
        type       : 'POST',
        url        : '/api/v1/courses/' + input_id.val() + "/update_teaser_material",
        processData: false,
        contentType: false,
        cache      : false,
        data       : form.serializefiles()
    }).success(function (data) {
        var block_teaser = $(".itemDetailInfo.material_teaser");
        block_teaser.find(".prev_teaser").removeClass("hide");
        block_teaser.find(".js_openFormUploadTeaser").addClass("hide");
        block_teaser.find(".prev_teaser .image img").attr('src', data.file.url);
        block_teaser.find(".prev_teaser .info .title span").text(data.file_name);
        block_teaser.find(".prev_teaser .info .weight").text(data.file_size.toString() + "  байт");
        clearFileInputField(form.find("input").attr('id'));
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

var deleteTeaserMaterial = function () {
    var input_id = formInputIdCourse();
    $.ajax({
        type: 'POST',
        url : '/api/v1/courses/' + input_id.val() + "/remove_teaser_material"
    }).success(function (data) {
        var block_teaser = $(".itemDetailInfo.material_teaser");
        block_teaser.find(".prev_teaser").addClass("hide");
        block_teaser.find(".js_openFormUploadTeaser").removeClass("hide");
    }).error(function () {
        show_error('Произошла ошибка', 3000);
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
            ".js_createAttachmentTest",
            ".js_changeAnswerInput",
            ".js_addTestToCourse",
            ".js_removeTestToCourse",
            ".js_loadIdsLeadsWebinar",
            ".js_createQuestionToTest"
        ]
    });

    $(document).on("click", ".js_setAttachmentType", setAttachmentType);

    $(document).on("click", ".selectAttachment", selectAttachment);

    $(document).on("click", ".js_addLeadingToWebinar", addLeadingToWebinar);
    $(document).on("click", ".js_openFormUploadTeaser", openFormUploadTeaser);
    $(document).on("click", ".js_deleteTeaserMaterial", deleteTeaserMaterial);

    $(document).on("click", ".js_removeLeadingToWebinar", function () {
        var btn = $(this);
        confirm("Вы действительно хотите удалить ведущего?", function () {
            removeLeadingToWebinar(btn);
        });

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

    $(document).on('keyup paste input propertychange click', '.form_group .js_onChangeEditAttachment', attachmentNameValidate);

    $(document).on('keyup paste input propertychange', '#contenterCourseProgram .js_changeAnswerInput', changeAnswerInput);
    $(document).on('click', '#contenterCourseProgram .js_openInfoParent', openInfoParent);
    $(document).on("keydown", "#contenterCourseProgram .js_getCloneQuestion", function (evt) {
        var keycode = (evt.keyCode?evt.keyCode:evt.which);
        if (keycode == '13'){
            getCloneQuestion($(this))
        }
        if (keycode == 8){
            removeAnswerToQuestion($(this));
        }
    });

    $(document).on('change', '.upload_teaser_material input', updateMaterialTeaser);

    removeExtraElement();
    sortableSections();
});
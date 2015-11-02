var installErrorBlock = function (arr_errors, block, valid) {
    if (arr_errors.length){
        block.addClass("error");
        block.find(".helpError .js_tooltip").html(arr_errors.join("<br/>"));
    } else {
        block.removeClass("error");
    }
    if (valid != false){
        validateAttachment();
    }
};

var validateTestQuestion = function () {
    var tests = $(".testIssue.currentQuestionId");
    $.each(tests, function (n, elem) {
        var arr_errors = [];
        var question = $(elem);
        var title_length = question.find(".js_changeQuestionInput").count_text_input();
        var answers = question.find(".questionItem");

        if (! title_length){
            arr_errors[arr_errors.length] = "Введите заголовок вопроса";
        }

        if (answers.find(".questionInput").length < 2){
            arr_errors[arr_errors.length] = "Должно быть не меньше 2 вариантов ответа";
        }

        if (answers.find("input:checked").length < 1){
            arr_errors[arr_errors.length] = "Укажите правильные варианты ответа в вопросах";
        }
        installErrorBlock(arr_errors, question);
    });
    //validateAttachment();
};

var validateTitleAttachment = function () {
    var blocks = $(".form_group.includeValidateForm");
    $.each(blocks, function (n, elem) {
        var block = $(elem);
        var inputs = block.find(".attachmentInput");
        $.each(inputs, function (n, elem) {
            var arr_errors = [];

            var input = $(elem);
            if (! input.count_text_input()){
                if (input.closest(".form_group").data('type') == 'title'){
                    arr_errors[arr_errors.length] = "Введите заголовок материала";
                }
                if (input.closest(".form_group").data('type') == 'description'){
                    arr_errors[arr_errors.length] = "Введите описание материала";
                }

            }
            installErrorBlock(arr_errors, input.closest(".form_group"));
        });
    });
};

validatePresentFile = function () {
    var inputs_file_type = $(".validateAttachmentFileType");
    $.each(inputs_file_type, function (n, elem) {
        var input = $(elem);
        var arr_errors = [];
        var blockEditFile = input.closest(".form_edit").find(".editFileUpload");
        var block_error_view = input.closest(".upload_attachments");
        if (! input.count_text_input()){
            input.closest(".upload_attachments").addClass("error");
            arr_errors[arr_errors.length] = "Добавьте материал";
        } else {
            block_error_view = blockEditFile;
            if (input.val() == "description"){
                var textarea = blockEditFile.find(".addedTxtDescription textarea");
                textarea.val(textarea.val().replace('<p><br data-mce-bogus="1"></p>', ''));
                if (! textarea.count_text_input() || !$( textarea.val()).text().length ){
                    arr_errors[arr_errors.length] = "Текст не может быть пустым";
                }
            }
        }
        if (! arr_errors.length){
            block_error_view.removeClass("error");
        }
        installErrorBlock(arr_errors, block_error_view, false);
    });
};

var validateAttachment = function () {
    //var error_blocks = $(".includeValidateForm.error");
    var parent_validBlock = $(".parentValidAttachment");
    $.each(parent_validBlock, function (n, elem) {
        var block = $(elem);
        var arr_errors = [];
        var error_blocks = block.find(".includeValidateForm.error");
        if (error_blocks.length){
            $.each(error_blocks, function (n, elem_err) {
                var block_err = $(elem_err);
                if (block_err.data('validate') == "test"){
                    arr_errors[arr_errors.length] = "Проверьте тест"
                }
                if (block_err.data('validate') == "attachment_title"){
                    arr_errors[arr_errors.length] = "Введите название материала"
                }
                if (block_err.data('validate') == "attachment_description"){
                    arr_errors[arr_errors.length] = "Введите описание материала"
                }
                if (block_err.data('validate') == "present_file"){
                    if(block_err.find(".attachmentShow").data('type') != "webinar"){
                        arr_errors[arr_errors.length] = "Вы забыли прикрепить материал"
                    }else{
                        arr_errors[arr_errors.length] = "Проверьте дату вебинара"
                    }

                }
            });
        }
        installErrorBlock(arr_errors.getUnique(), block.find(".info_attachment, .parentFinalTest .info_test"), false);
    });

    if ($("#contenterCourseProgram").length){
        if (! $(".info_attachment.error, .validateSection.error, .validateTest.error").length){
            $(".contenter_courses_programm").removeClass("error");
        } else {
            $(".contenter_courses_programm").addClass("error");
        }
    }
};

var validateFinalTest = function (){
    if (!$(".js_addTestToCourse.noValid").length){
        if ($("#contenterCourseProgram").length && !$(".parentFinalTest").length ){
            var block = $(".section.add_new.js_addTestToCourse");
            var arr_errors = [];
            arr_errors[arr_errors.length] = "Добавьте финальный тест";
            installErrorBlock(arr_errors, block, false);
        }
    }
};

var validateCourse = function () {
    validateCourseTitle();
    validateCourseCategories();
    installErrorHeader();
};

var installErrorHeader = function () {
    if ($("#courseEditContenter").length){
        if ($(".validateFormCourse.error").length){
            $(".contenter_courses_edit").addClass("error");
        } else {
            $(".contenter_courses_edit").removeClass("error");
        }
    }
};

var validateCourseCategories = function () {
    var block = $(".itemDetailInfo.validateCourseCategories");
    var categories = block.find(".description__Item .allCategoriesDescriptionCourse .category");
    var arr_errors = [];
    if (categories.length){
        block.removeClass("error");
    } else {
        arr_errors[arr_errors.length] = "Добавьте категорию";
        block.addClass("error");
    }
    installErrorBlock(arr_errors, block, false);
    installErrorHeader();
};

var validateCourseTitle = function () {
    var inputs = $(".js_validateCourseTitle");
    $.each(inputs, function (n, elem) {
        var arr_errors = [];
        var block = $(elem);
        if (! block.count_text_input()){
            if (block.attr('name') == "course[title]"){
                arr_errors[arr_errors.length] = "Введите название"
            }
            if (block.attr('name') == "course[description]"){
                arr_errors[arr_errors.length] = "Введите описание"
            }
        }
        installErrorBlock(arr_errors, block.closest(".validateFormCourse"), false);
    });
};

var validateSections = function(){
    var sections = $(".validateSections");
    $.each(sections, function (n, elem) {
        var arr_errors = [];
        var section = $(elem);
        var input_title = section.find(".input_section input.section_title");
        var attachments = section.find(".descriptionSection .allAttachmentsSection .attachment.item");
        if (!input_title.count_text_input()){
            arr_errors[arr_errors.length] = "Введите заголовок раздела"
        }
        if (!attachments.length){
            arr_errors[arr_errors.length] = "Добавьте хотя бы один материал"
        }
        installErrorBlock(arr_errors, section.find(".input_section"), false);
    });
};

var validateWebinar = function(){
    var webinars = $(".addedWebinar.itemFile");
    $.each(webinars, function (n, elem) {
        var arr_errors = [];
        var webinar = $(elem);
        var date = webinar.find(".startDate input");
        var time_h = webinar.find(".startHour input[data-type='hour']");
        var time_m = webinar.find(".startHour input[data-type='min']");
        var duration = webinar.find(".duration input[name='webinar[duration]']");
        if (!date.count_text_input()) arr_errors[arr_errors.length] = "Установите дату вебинара";
        if (!duration.count_text_input()) arr_errors[arr_errors.length] = "Установите продолжительность вебинара";
        if (!time_h.count_text_input() || !time_m.count_text_input()) arr_errors[arr_errors.length] = "Установите время вебинара";
        installErrorBlock(arr_errors, webinar.closest(".editFileUpload"), false);
    });
};

var allValidateForms = function () {
    if (formInputIdCourse().val() != "new"){
        validateTestQuestion();
        validateTitleAttachment();
        validatePresentFile();
        validateSections();
        validateFinalTest();
        validateWebinar();
        validateAttachment();
        ////
        validateCourse();
        for_tooltip();
    }
};

pageLoad(function () {
    var blocks_valid = "#contenterCourseProgram, #courseEditContenter";
    if( $(blocks_valid).length ){
        allValidateForms();
        $(document).on('click', blocks_valid, allValidateForms);
    }
});
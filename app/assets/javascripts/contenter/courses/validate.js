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
            arr_errors[arr_errors.length] = "Должен быть хотя бы один правельный ответ";
        }
        installErrorBlock(arr_errors, question);
    });
    //validateAttachment();
};

var validateTitleAttachment = function () {
    var blocks = $(".formGroupAttachmentTitle.includeValidateForm");
    $.each(blocks, function (n, elem) {
        var block = $(elem);
        var arr_errors = [];
        var inputs = block.find(".attachmentInput");
        $.each(inputs, function (n, elem) {
            var input = $(elem);
            if (! input.count_text_input()){
                if (input.closest(".form_group").data('type') == 'title'){
                    arr_errors[arr_errors.length] = "Введите заголовок материала";
                }
                if (input.closest(".form_group").data('type') == 'description'){
                    arr_errors[arr_errors.length] = "Введите описание материала";
                }

            }
        });
        installErrorBlock(arr_errors, block);
    });
};

validatePresentFile = function(){
    var inputs_file_type = $(".validateAttachmentFileType");
    $.each(inputs_file_type, function (n, elem) {
        var input = $(elem);
        var arr_errors = [];
        var blockEditFile = input.closest(".form_edit").find(".editFileUpload");
        var block_error_view = input.closest(".upload_attachments");
        if (!input.count_text_input()){
            input.closest(".upload_attachments").addClass("error");
            arr_errors[arr_errors.length] = "Добавьте материал";
        }else{
            block_error_view = blockEditFile;
            if (input.val() == "description"){

                if (!blockEditFile.find(".addedTxtDescription textarea").count_text_input()){
                    arr_errors[arr_errors.length] = "Текст не может быть пустым";
                }
            }
        }
        if (!arr_errors.length){
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
                    arr_errors[arr_errors.length] = "Проверьте название и описание материала"
                }
                if (block_err.data('validate') == "present_file"){
                    arr_errors[arr_errors.length] = "Проверьте материал"
                }
            });
        }
        installErrorBlock(arr_errors, block.find(".info_attachment, .parentFinalTest"), false);
    });

    if ($("#contenterCourseProgram").length){
        if (! $(".info_attachment.error").length){
            $(".contenter_courses_programm").removeClass("error");
        } else {
            $(".contenter_courses_programm").addClass("error");
        }
    }
};

var validateCourse = function(){
    validateCourseTitle();
    validateCourseCategories();
    installErrorHeader();
};

var installErrorHeader = function(){
    if ($("#courseEditContenter").length){
        if($(".validateFormCourse.error").length){
            $(".contenter_courses_edit").addClass("error");
        }else{
            $(".contenter_courses_edit").removeClass("error");
        }
    }
};

var validateCourseCategories = function (){
    var block = $(".itemDetailInfo.validateCourseCategories");
    var categories = block.find(".description__Item .allCategoriesDescriptionCourse .category")
    var arr_errors = [];
    if (categories.length){
        block.removeClass("error");
    }else{
        arr_errors[arr_errors.length] = "Выберете категорию";
        block.addClass("error");
    }
    installErrorBlock(arr_errors, block, false);
    installErrorHeader();
};

var validateCourseTitle = function () {
    var inputs = $(".js_validateCourseTitle");
    var arr_errors = [];
    $.each(inputs, function (n, elem) {
        var block = $(elem);
        if (! block.count_text_input()){
            if (block.attr('name') == "course[title]"){
                arr_errors[arr_errors.length] = "Введите заголовок курса"
            }
            if (block.attr('name') == "course[description]"){
                arr_errors[arr_errors.length] = "Введите описание курса"
            }
        }
    });
    installErrorBlock(arr_errors, inputs.closest(".course__description-content"), false);
};

var allValidateForms = function () {
    validateTestQuestion();
    validateTitleAttachment();
    validatePresentFile();
    validateAttachment();
    validateCourse();
};

pageLoad(function () {
    allValidateForms();
    $(document).on('click', '#contenterCourseProgram, #courseEditContenter', allValidateForms);
});
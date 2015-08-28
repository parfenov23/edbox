var installErrorBlock = function (arr_errors, block, valid) {
    if (arr_errors.length){
        block.addClass("error");
        block.find(".helpError .js_tooltip").html(arr_errors.join("<br/>"))
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
            });
        }
        installErrorBlock(arr_errors, block.find(".info_attachment"), false);
    });
    if ($("#contenterCourseProgram").length){
        if (! $(".info_attachment.error").length){
            $(".contenter_courses_programm").removeClass("error");
        } else {
            $(".contenter_courses_programm").addClass("error");
        }
    }
};

var allValidateForms = function () {
    validateTestQuestion();
    validateTitleAttachment();
    validateAttachment();
};

pageLoad(function () {
    allValidateForms();
    $(document).on('click', '#contenterCourseProgram', allValidateForms);
});
var validTestForm = function (form) {
    var testItems = $(form).find('.test-item');
    var invalidTestItemsIds = [];
    $.each(testItems, function (i, element) {
        if ($(element).find(':checked').length){
            if (! $(element).hasClass('is__not-activ')){
                $(element).addClass('is__not-activ');
            }
        } else {
            if ($(element).hasClass('is__not-activ')){
                $(element).removeClass('is__not-activ');
            }
            invalidTestItemsIds.push($(element).attr('name'));
        }
    });
    return invalidTestItemsIds;
};

var warningTestText = function (invalidTestItemsIds) {
    var text = 'Для завершения теста вам необходимо ответить на вопрос ';
    text += invalidTestItemsIds.join(', вопрос ');
    text += '.';
    return text;
};

var testResult = function (response) {
    var form = $('#tests');
    var text = 'Поздравляем! Вы сдали тест. Вы прошли тест с результатом ' +
        response.result + '%. Если вы хотите улучшить свой результат, ' +
        'вы может пересдать тест и мы засчитаем вашу лучшую попытку.';

    confirm(text, function () {
        window.location.href = '/course_description?id=' + form.data('course_id') + '&attachment_id=' + form.data('att_id')
    });
    $(".pop_up_confirm .js_closePopupConfirmNo").hide();
    $(".pop_up_confirm .js_actionYesStart").text('OK');
    //warning(text, 'ОК');
};

var submitFromTest = function () {
    var form = $('#tests');
    var invalidTestItemsIds = validTestForm(form);
    if (invalidTestItemsIds.length){
        var text = warningTestText(invalidTestItemsIds);
        warning(text, 'OK');
    } else {
        var data = form.serialize();
        $.ajax({
            type   : 'POST',
            url    : '/api/v1/tests/' + form.data('id') + '/result',
            data   : data,
            success: function (e) {
                testResult(e);
            },
            error  : function () {
                show_error('Ошибка', 3000);
            }
        });
    }
    return true;
};

$(document).ready(function () {
    $(document).on('click', '#tests .js_submitFormTest', submitFromTest);

    var result = $('#tests .result-block');
    if (result.length){
        result.hide();
    }
});

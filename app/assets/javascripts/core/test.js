var validTestForm = function (form) {
    var testItems = $(form).find('.test-item');
    var invalidTestItemsIds = [];
    $.each(testItems, function (i, element) {
        if ($(element).find(':checked').length){
            if (! $(element).hasClass('error')){
                $(element).addClass('error');
            }
        } else {
            if ($(element).hasClass('error')){
                $(element).removeClass('error');
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
    if (response.result < 100){
        var text = 'Хорошая попытка! Вы прошли тест, но набрали всего лишь ' +
            response.result + '% из 100 возможных. Мы можем принять ваши результаты как есть или же вы можете попробовать пройти тест еще раз.' +
            ' Набрать 100% правильных ответов и получить Сертификат.';

        confirm(text, function () {
            window.location.reload();
        });
        $(".pop_up_confirm .js_closePopupConfirmNo").text('Принять мои результаты').click(function () {
            window.location.href = '/course_description?id=' + form.data('course_id') + '&attachment_id=' + form.data('att_id');
        });
        $(".pop_up_confirm .js_actionYesStart").text('Пересдать тест');
    } else {
        openPopupImg(response.certificate,
            'Поздравляем вас!',
            'Вы только что успешно сдали итоговый тест курса «' + $.trim(response.course_name) + '». Этот сертификат — ваш. Вместе с навыками и знаниями, которые позволят вам' +
            ' продовать больше и чаще.');

        $(document).on('click', '.pop_up_confirm', function (event) {
            var evt = evt || event;
            var target = evt.target || evt.srcElement;
            if ($(target).hasClass("pop_up_confirm")){
                window.location.href = '/course_description?id=' + form.data('course_id') + '&attachment_id=' + form.data('att_id')
            }
        });
        var elemPluso = document.querySelectorAll("div.pluso")[0];
        var cert_id = response.certificate.replace('/system/tests_cert/', '').replace('.png', '');
        var url_page = current_domain() + '/course_cert?id=' + cert_id + "&course_id=" + response.course_id;
        //elemPluso.pluso.params.url = current_domain() + "/course_description?id=" + response.course_id;
        elemPluso.pluso.params.url = url_page;
        elemPluso.pluso.params.image = current_domain() + response.certificate;
        elemPluso.pluso.params.title = "Горжусь сертификатом ADCONSULT Online!";
        elemPluso.pluso.params.description = response.course_name;
        $("#btnPrintPage a").attr('href', url_page + '&print=true');
    }
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
    $(document).on('click', '.js_submitFormTest', submitFromTest);

    var result = $('#tests .result-block');
    if (result.length){
        result.hide();
    }
});

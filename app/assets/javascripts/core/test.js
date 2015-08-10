$(document).ready(function () {
    $('img:last').load(function(){
        $('#tests #submit').click(function (e) {
            e.preventDefault();
            var form =  $('#tests');
            var invalidTestItemsIds = validTestForm(form);
            if (invalidTestItemsIds.length){
                var text = warningTestText(invalidTestItemsIds)
                warning(text, 'ответить')
            } else {
                var data = form.serialize();
                $.ajax({
                    type   : 'POST',
                    url    : '/tests/complete',
                    data   : data,
                    success: function (e) {
                        testResult(e);
                    },
                    error  : function () {
                        show_error('Ошибка', 3000);
                    }
                });
            }
        });
    });
});

$(document).ready(function () {
    $('img:last').load(function () {
        var result = $('#tests .result-block');
        if (result.length) {
            result.hide();
        }
    });
});

var validTestForm = function(form){
    var testItems = $(form).find('.test-item')
    invalidTestItemsIds = [];
    $.each(testItems, function(i, element){
        if ($(element).find(':checked').length) {
            if (!$(element).hasClass('is__not-activ')){
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

var warningTestText = function(invalidTestItemsIds){
    var text = 'Для завершения теста вам необходимо ответить на вопрос ';
    text += invalidTestItemsIds.join(', вопрос ');
    text += '.';
    return text;
};

var testResult = function(response){
    var result = $('#tests .result-block');
    var text = 'Ваш результат прохождения теста ' + response.result + '%. Вы ответили правильно на ' + response.right_answers + ' вопросов из ' + response.all_questions + '.'
    result.find('.description').text(text);
    var test = $('#tests .test-block');
    test.hide();
    result.show();
}
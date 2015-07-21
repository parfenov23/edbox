$(document).ready(function () {
    $("img:last").load(function(){
        $("#tests #submit").click(function (e) {
            e.preventDefault();
            var form =  $("#tests");
            var data = form.serialize();
            $.ajax({
                type   : 'POST',
                url    : '/tests/complete',
                data   : data,
                success: function (e) {
                    message = 'Результат: ' + e.result + ' баллов';
                    show_error(message, 3000);
                },
                error  : function () {
                    show_error('Ошибка', 3000);
                }
            });
        });
    });
});
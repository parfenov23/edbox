$(document).ready(function () {
    $("img:last").load(function(){
        $('#navigation .btnCurrent').first().addClass("selected");
        $('#navigation').show();
        $("#formElem fieldset").first().show();

        $('#navigation .btnCurrent').click(function (e) {
            var btn = $(this);
            var id = btn.data("id");

            $('#navigation .btnCurrent.selected').removeClass("selected");
            btn.addClass("selected");

            $("#formElem fieldset").hide();
            $("#formElem fieldset.step" + id).show();
            e.preventDefault();
        });

        $("#navigation #submit").click(function (e) {
            e.preventDefault();
            var form =  $("#formElem");
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
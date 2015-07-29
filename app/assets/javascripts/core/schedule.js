$(document).ready(function () {
    $('img:last').load(function () {
        $('.schedule-calendar .item').on('click', function () {
            var date = $(this).data('date');
            if (typeof date != 'undefined'){
                $.ajax({
                    type   : 'POST',
                    url    : '/schedule/day',
                    data   : {date: date},
                    success: function (e) {
                        $('#js-schedule-calendar').html(e);
                    },
                    error  : function () {
                        show_error('Ошибка', 3000);
                    }
                });
            }
        });
    });
});
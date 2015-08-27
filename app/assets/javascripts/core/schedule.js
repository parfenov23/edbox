$(document).ready(function () {
    $('.schedule-calendar .item').on('click', function () {
        var date = $(this).data('date');
        var group = $(this).data('group');
        if (typeof date != 'undefined'){
            $.ajax({
                type   : 'POST',
                url    : '/schedule/day',
                data   : {
                    date: date,
                    group: group
                },
                success: function (e) {
                    $('#js-schedule-calendar').html(e);
                    $('.close-filter').click(function () {
                        $('#js-schedule-calendar').removeClass('show');
                    });
                    bind_block();
                },
                error  : function () {
                    show_error('Ошибка', 3000);
                }
            });
        }
    });
});

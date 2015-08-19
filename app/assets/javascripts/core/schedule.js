$(document).ready(function () {
    $('img:last').load(function () {
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
                        //$('.js__select-calendar').hover((function () {
                        //    $(this).addClass('is__active');
                        //    $('.js__backing').addClass('is__active');
                        //}), function () {
                        //    if ($('#ui-datepicker-div').is(':hidden')) {
                        //        $(this).removeClass('is__active');
                        //    }
                        //});
                        //includeDatePicker();
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
});

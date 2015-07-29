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
                        $('.js__select-calendar').hover((function () {
                            $(this).addClass('is__active');
                            $('.js__backing').addClass('is__active');
                        }), function () {
                            console.log(33);
                            if ($('#ui-datepicker-div').is(':hidden')) {
                                console.log(0);
                                $(this).removeClass('is__active');
                            }
                        });
                        includeDatePicker();
                    },
                    error  : function () {
                        show_error('Ошибка', 3000);
                    }
                });
            }
        });
    });
});

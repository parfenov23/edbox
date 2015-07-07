var addGroup = function(){
    var btn = $(this);
    var form = btn.closest("form");
    var data = form.serialize();
    show_error('Загрузка', 3000);
    $.ajax({
        type: 'POST',
        url : '/api/v1/groups',
        data: data
    }).success(function (data) {
        show_error('Группа создана', 3000);
        window.location.href = "/group?id=" + data.id
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
    return true;
};

$(document).ready(function () {
    $(document).on('click', '#groups .newGroup .submit-area .submitBtn', addGroup);
});

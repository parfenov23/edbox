var btnRemoveGroup;
var removeGroup = function () {
    if (btnRemoveGroup != undefined){
        show_error('Загрузка', 3000);
        $.ajax({
            type: 'delete',
            url : '/api/v1/groups/' + btnRemoveGroup.data("id"),
        }).success(function () {
            show_error('Группа удалена', 3000);
            window.location.href = "/group"
        }).error(function () {
            show_error('Произошла ошибка', 3000);
        });
    }
    return true;
};

$(document).ready(function () {
    $(document).on('click', '#infoGroup .group-edit-menu .delete-item', function () {
        btnRemoveGroup = $(this);
        confirm("Вы уверены что хотите удалить группу?", removeGroup)
    });
});

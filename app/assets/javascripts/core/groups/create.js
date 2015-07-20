var addGroup = function(btn){
    var form = btn.closest("form");
    var data = form.serialize();
    show_error('Загрузка', 3000);
    $.ajax({
        type: 'POST',
        url : '/api/v1/groups',
        data: data
    }).success(function (data) {
        show_error('Группа создана', 3000);
        closePopupFormGroup();
        setTimeout(function(){
            window.location.href = "/group?id=" + data.id
        }, 500)
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
    return true;
};

var updateGroup = function(btn){
    var form = btn.closest("form");
    var data = form.serialize();
    show_error('Загрузка', 3000);
    $.ajax({
        type: 'PUT',
        url : '/api/v1/groups/'+ btn.data('id'),
        data: data
    }).success(function (data) {
        show_error('Группа обновленна', 3000);
        closePopupFormGroup();
        setTimeout(function(){
            window.location.href = "/group?id=" + data.id
        }, 500)

    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
    return true;
};

var saveGroup = function(){
    var btn = $(this);
    if (btn.data('type') == 'new'){
        addGroup(btn)
    }else{
        updateGroup(btn);
    }
};

var closePopupFormGroup = function(){
    $("#infoGroup .form_group").hide().find(".formGroup-new, .formGroup-edit").hide();
};

var openPopupNewGroup = function(){
    closePopupFormGroup();
    $("#infoGroup .form_group").show().find(".formGroup-new").show();
};
var openPopupEditGroup = function(){
    closePopupFormGroup();
    $("#infoGroup .form_group").show().find(".formGroup-edit").show();
};

$(document).ready(function () {
    $(document).on('click', '#groups .newGroup .submit-area .submitBtn',
        function(){
            addGroup($(this));
        });
    $(document).on('click', '.js_openPopupNewGroup', openPopupNewGroup);
    $(document).on('click', '.js_openPopupEditGroup', openPopupEditGroup);
    $(document).on('click', '.form_group .js_closePopupFormGroup', closePopupFormGroup);
    $(document).on('click', '.form_group .js_saveGroup', saveGroup);
});

var changeCategoryInput = function(){
    var btn = $(this);
    $.ajax({
        type: 'PUT',
        url : '/api/v1/categories/' + btn.data("id"),
        data: {category: {title: btn.val()}}
    }).success(function (data) {
        loadBindOnChangeInputAdminCategory();
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

var removeCategoryInAdmin = function(btn){
    var tag_name = btn.prop("tagName");
    var valid = false;
    if (tag_name == "DIV"){
        valid = true;
    }
    if (tag_name == "INPUT"){
        if (!btn.val().length){
            valid = true;
        }
    }
    if (valid){
        confirm("Вы действительно хотите удалить категорию?", function () {
            $.ajax({
                type: 'POST',
                url : '/api/v1/categories/' + btn.data("id") + '/remove'
            }).success(function (data) {
                btn.closest(".tag").remove();
            }).error(function () {
                show_error('Произошла ошибка', 3000);
            });
        });
    }
};

var loadBindOnChangeInputAdminCategory = function(){
    $('#categoriesContenterAdmin .js_changeCategoryInput').change(changeCategoryInput);
};

var getCloneCategory = function (input) {
    var parentBlock = input.closest(".tag");
    var next_block = parentBlock.next();
    if (next_block.length){
        SetCaretAtEnd(next_block.find(".titleTagName")[0])
    } else {
        createCategoryInAdmin(parentBlock);
    }
};

var createCategoryInAdmin = function(){
    $.ajax({
        type: 'POST',
        url : '/api/v1/categories',
        data: {type: "html"}
    }).success(function (data) {
        $("#categoriesContenterAdmin .allTags").append($(data));
        SetCaretAtEnd($("#categoriesContenterAdmin .allTags .titleTagName:last")[0]);
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

pageLoad(function(){
    loadBindOnChangeInputAdminCategory();
    $(document).on("keydown", "#categoriesContenterAdmin .js_getCloneCategory", function (evt) {
        var keycode = (evt.keyCode?evt.keyCode:evt.which);
        if (keycode == '13'){
            getCloneCategory($(this));
        }
        if (keycode == 8){
            removeCategoryInAdmin($(this))
        }
    });
    $(document).on('click', "#categoriesContenterAdmin .js_removeCategoryInAdmin", function(){
        removeCategoryInAdmin($(this));
    })
});

var changeTagInput = function () {
    var btn = $(this);
    $.ajax({
        type: 'PUT',
        url : '/api/v1/tags/' + btn.data("id"),
        data: {tag: {title: btn.val()}}
    }).success(function (data) {
        loadBindOnChangeInputAdmin();
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

var removeTagInAdmin = function (btn) {
    var tag_name = btn.prop("tagName");
    var valid = false;
    console.log(tag_name);
    if (tag_name == "DIV"){
        valid = true;
    }
    if (tag_name == "INPUT"){
        if (! btn.val().length){
            valid = true;
        }
    }
    if (valid){
        confirm("Вы действительно хотите удалить тег?", function () {
            $.ajax({
                type: 'POST',
                url : '/api/v1/tags/' + btn.data("id") + '/remove'
            }).success(function (data) {
                btn.closest(".tag").remove();
            }).error(function () {
                show_error('Произошла ошибка', 3000);
            });
        });
    }
};

var loadBindOnChangeInputAdmin = function () {
    $('#tagsContenterAdmin .js_changeTagInput').change(changeTagInput);
};

var getCloneTag = function (input) {
    var parentBlock = input.closest(".tag");
    var next_block = parentBlock.next();
    if (next_block.length){
        SetCaretAtEnd(next_block.find(".titleTagName")[0])
    } else {
        createTagInAdmin(parentBlock);
    }
};

var createTagInAdmin = function () {
    $.ajax({
        type: 'POST',
        url : '/api/v1/tags',
        data: {type: "html"}
    }).success(function (data) {
        $("#tagsContenterAdmin .allTags").append($(data));
        SetCaretAtEnd($("#tagsContenterAdmin .allTags .titleTagName:last")[0]);
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

pageLoad(function () {
    loadBindOnChangeInputAdmin();
    $(document).on("keydown", "#tagsContenterAdmin .js_getCloneTags", function (evt) {
        var keycode = (evt.keyCode?evt.keyCode:evt.which);
        if (keycode == '13'){
            getCloneTag($(this));
        }
        if (keycode == 8){
            removeTagInAdmin($(this));
        }
    });
    $(document).on('click', "#tagsContenterAdmin .js_removeTagInAdmin", function () {
        removeTagInAdmin($(this));
    });
});

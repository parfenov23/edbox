var noteUpdate = function(e){
    e.preventDefault();
    var form = $(e.target).closest('form');
    var data = form.serialize();
    $.ajax({
        type   : 'POST',
        url    : '/notes/update',
        data   : data,
        success: function (e) {
            $('#js-notification-courses .js_addNoteBlock').append(e);
            bind_block();
            var note_text = form.find('textarea');
            note_text.val('');
        },
        error  : function () {
            show_error('Ошибка', 3000);
        }
    });
    return true;
};

var noteDestroy = function () {
    var note_id = $(this).data('note_id');
    if (typeof note_id != 'undefined'){
        $.ajax({
            type: 'DELETE',
            url : '/notes/' + note_id
        }).success(function () {
            show_error('Заметка удалена', 3000);
            window.location.href = "/notes"
        }).error(function () {
            show_error('Произошла ошибка', 3000);
        });
    }
    return true;
};

var noteDestroyMenu = function () {
    var note_id = $(this).data('note_id');
    var noteItem = $(this.closest('.js_noteItem'));
    if (typeof note_id != 'undefined'){
        $.ajax({
            type: 'DELETE',
            url : '/notes/' + note_id
        }).success(function () {
            noteItem.remove();
            show_error('Заметка удалена', 3000);
        }).error(function () {
            show_error('Произошла ошибка', 3000);
        });
    }
    return true;
};

var noteInfo = function () {
    var note_id = $(this).data('note_id');
    if (typeof note_id != 'undefined'){
        $.ajax({
            type   : 'POST',
            url    : '/notes/' + note_id + '/info',
            data   : {
                note_id : note_id
            },
            success: function (e) {
                $('#js-notes-courses').html(e);
                bind_block();
            },
            error  : function () {
                show_error('Ошибка', 3000);
            }
        });
    }
};

pageLoad(function(){
    $(document).on('click', '.js_noteUpdate', noteUpdate);
    $(document).on('click', '.js_noteDestroy', noteDestroy);
    $(document).on('click', '.js_noteInfo', noteInfo);
    $(document).on('click', '.js_noteDestroyMenu', noteDestroyMenu);
});

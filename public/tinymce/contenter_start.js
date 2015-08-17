function init_tiny() {
    tinymce.init({
        selector: "textarea.js_includeTiny",
        height  : 300,
        menu    : { // this is the complete default configuration
            //edit   : {title : 'Редактирование'  , items : 'undo redo | cut copy paste pastetext | selectall'},
            insert: {title: 'Insert', items: 'link media | template hr'},
            //format : {title : 'Форматирование', items : 'bold italic underline strikethrough superscript subscript | formats | removeformat'},
            table : {title: 'Table', items: 'inserttable tableprops deletetable | cell row column'},
            tools : {title: 'Tools', items: 'spellchecker code'}
        },
        setup   : function (editor) {
            editor.on('change', function (e) {
                var editor_tiny = $(e.target.editorContainer);
                var form = editor_tiny.closest("form");
                var textarea = form.find("textarea[name='attachment[full_text]']");
                textarea.val(e.target.getBody().innerHTML);
                onChangeEditAttachment(editor_tiny);
            });
        }
    });
}

$(document).ready(function(){
    init_tiny();
});
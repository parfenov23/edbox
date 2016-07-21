function init_tiny() {
    tinymce.init({
        selector: "textarea.js_includeTiny",
        height  : 300,
        plugins: [
            "advlist autolink lists link image charmap print preview anchor",
            "searchreplace visualblocks code fullscreen",
            "insertdatetime media table contextmenu paste imagetools"
        ],
        toolbar: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image",
        imagetools_cors_hosts: ['www.tinymce.com', 'codepen.io'],
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
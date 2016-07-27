function init_tiny() {
    tinymce.init({
        selector             : "textarea.js_includeTiny",
        height               : 300,
        plugins              : [
            "advlist autolink lists link image charmap print preview anchor",
            "searchreplace visualblocks code fullscreen",
            "insertdatetime media table contextmenu paste imagetools, uploadimage"
        ],
        toolbar              : "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image |" +
        " uploadimage",
        imagetools_cors_hosts: ['www.tinymce.com', 'codepen.io'],
        setup                : function (editor) {
            editor.on('change', function (e) {
                var editor_tiny = $(e.target.editorContainer);
                var form = editor_tiny.closest("form");
                var textarea = form.find("textarea[name='attachment[full_text]']");
                textarea.val(e.target.getBody().innerHTML);
                if (textarea.length){
                    onChangeEditAttachment(editor_tiny);
                }else{
                    editor_tiny.closest(".description").find("textarea").val(e.target.getBody().innerHTML);
                    var input_id = formInputIdCourse();
                    var id_course = input_id.val();
                    if (id_course == "new"){
                        createCourseContenter(form.serialize());
                    } else {
                        updateCourseContenter(form.serialize(), id_course);
                    }
                }
            });
        }
    });
}
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
        imagetools_cors_hosts: ['www.tinymce.com', 'codepen.io']
    });
}
init_tiny();
$(document).ready(function () {
    $("#open_descriptio").click(function () {
        $(this).closest(".form-group").find(".mce-tinymce.mce-container.mce-panel").show();
        $(this).hide();
    })
});
$(document).on('change', '.btn-file :file', function () {
    var input = $(this),
        numFiles = input.get(0).files?input.get(0).files.length:1,
        label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
    input.trigger('fileselect', [numFiles, label]);
});

$(document).ready(function () {
    $('.btn-file :file').on('fileselect', function (event, numFiles, label) {

        var input = $(this).parents('.input-group').find(':text'),
            log = numFiles > 1?numFiles + ' files selected':label;

        if (input.length){
            input.val(log);
        } else {
            if (log) alert(log);
        }

    });
    $('#sandbox-container .input-group.date').datepicker({
        format        : "20yy-mm-dd",
        startView     : 1,
        language      : "ru",
        multidate     : false,
        autoclose     : true,
        todayHighlight: true
        //toggleActive: true
    });
});


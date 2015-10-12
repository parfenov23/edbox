function init_tiny(){
    tinymce.init({
        selector: "textarea",
        height  : 300,
        plugins: "code"
        //menu : { // this is the complete default configuration
        //    //edit   : {title : 'Редактирование'  , items : 'undo redo | cut copy paste pastetext | selectall'},
        //    //insert : {title : 'Insert', items : 'link media | template hr'},
        //    ////format : {title : 'Форматирование', items : 'bold italic underline strikethrough superscript subscript | formats | removeformat'},
        //    //table  : {title : 'Table' , items : 'inserttable tableprops deletetable | cell row column'},
        //    //tools  : {title : 'Tools' , items : 'spellchecker code'}
        //}
    });
}
init_tiny();
$(document).ready(function(){
    $("#open_descriptio").click(function(){
        $(this).closest(".form-group").find(".mce-tinymce.mce-container.mce-panel").show();
        $(this).hide();
    })
});
$(document).on('change', '.btn-file :file', function() {
    var input = $(this),
        numFiles = input.get(0).files ? input.get(0).files.length : 1,
        label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
    input.trigger('fileselect', [numFiles, label]);
});

$(document).ready( function() {
    $('.btn-file :file').on('fileselect', function(event, numFiles, label) {

        var input = $(this).parents('.input-group').find(':text'),
            log = numFiles > 1 ? numFiles + ' files selected' : label;

        if( input.length ) {
            input.val(log);
        } else {
            if( log ) alert(log);
        }

    });
    $('#sandbox-container .input-group.date').datepicker({
        format: "20yy-mm-dd",
        startView: 1,
        language: "ru",
        multidate: false,
        autoclose: true,
        todayHighlight: true
        //toggleActive: true
    });
});


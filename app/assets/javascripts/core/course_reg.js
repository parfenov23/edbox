var openFormRegistration = function(){
    var popup = $("#formCourseRegPopUp");
    popup.show();
    $(document).scrollTop( popup.offset().top);
};

pageLoad(function(){
    $(document).on('click', '.js_openFormRegistration', openFormRegistration);
});
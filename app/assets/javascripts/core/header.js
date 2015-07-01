$(document).ready(function(){
    $("#header__holder .header__apps").click(function(){
        var evt = evt || event;
        var target = evt.target || evt.srcElement;
        if ($(target).closest(".menu__apps").length == 0){
            var btn = $(this);
            btn.find(".menu__apps").toggle()
        }
    });
    $(document).click(function(){
        var evt = evt || event;
        var target = evt.target || evt.srcElement;
        if ($(target).closest(".header__apps").length == 0){
            $("#header__holder .header__apps .menu__apps").hide()
        }
    })
});
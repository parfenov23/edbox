$(document).ready(function(){
    $(".js_openHeaderAppsBtn").click(function(event){
        var evt = evt || event;
        var target = evt.target || evt.srcElement;
        if ($(target).closest(".menu__apps").length == 0){
            var btn = $(this);
            btn.find(".menu__apps").toggle()
        }

    });
    $(document).click(function(event){
        var evt = evt || event;
        var target = evt.target || evt.srcElement;
        if ($(target).closest(".js_openHeaderAppsBtn").length == 0){
            $(".js_openHeaderAppsBtn .menu__apps").hide()
        }
    })
});
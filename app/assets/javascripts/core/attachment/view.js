jQuery.fn.center = function () {
    this.css("position","absolute");
    this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) +
    $(window).scrollTop()) + "px");
    this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) +
    $(window).scrollLeft()) + "px");
    return this;
}

$(document).ready(function () {
    var video = $(".content-video video");
    if (video.length > 0){
        var body = $("body");
        body.attr("style", "background-color : #252525;");
        //video.center();
        $(".content-video").center();
    }
});
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
    }
});

$(document).ready(function () {
    var video = $(".content-audio audio");
    if (video.length > 0){
        $(".content-audio").center();
    }
});

//$(document).ready(function () {
//    $('#audio-play.play').click(function (e) {
//        $('#audio')[0].play();
//        var playBtn = e.target;
//        $(playBtn).removeClass('play');
//        $(playBtn).addClass('pause');
//        $(playBtn).text('pause');
//    })
//});
//
//$(document).ready(function () {
//    $('#audio-play.pause').click(function (e) {
//        $('#audio')[0].pause();
//        var pauseBtn = e.target;
//        $(pauseBtn).removeClass('pause');
//        $(pauseBtn).addClass('play');
//        $(pauseBtn).text('play');
//    })
//});

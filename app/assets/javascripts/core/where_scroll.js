var tempScrollTop = 0;
var currentScrollTop = 0;
var tempScrollTopTime = 0;
var currentScrollTopTime = 0;

window.where_scroll = "default"; // направление

$(window).scroll(function (event) {

    currentScrollTop = $(window).scrollTop();
    currentScrollTopTime = event.timeStamp;

    if (tempScrollTop < currentScrollTop){
        window.where_scroll = "down"; // крутнули вниз колесо
    }
    else if (tempScrollTop > currentScrollTop){
        window.where_scroll = "up"; // крутнули вверх колесо
    }

    tempScrollTop = currentScrollTop;
    tempScrollTopTime = currentScrollTopTime;
    console.log(window.where_scroll)
});

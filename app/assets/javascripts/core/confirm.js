var btn_yes_action = function(){};

function confirm(text, action){
    var popup = $(".pop_up_confirm").not(".pop_up_confirm.noConfirmOpen");
    popup.find(".inner .description").text(text);
    btn_yes_action = action;
    popup.addClass("h__PopupDisplayFlex");

}

function warning(text, actionText, btnAction){
    var popup = $('.pop_up_confirm').not('.popup__img, .pop_up_confirm.noConfirmOpen');
    popup.find('.inner .description').text(text);
    popup.find('.action-btn .js_closePopupConfirmNo').attr('style', 'display:none');
    popup.find('.action-btn .js_actionYesStart').text(actionText);
    if (btnAction == undefined) btnAction = defaultConfirm;
    btn_yes_action = btnAction;
    popup.addClass("h__PopupDisplayFlex");
}

var closePopupConfirm = function (event) {
    var evt = evt || event;
    var target = evt.target || evt.srcElement;
    if ($(target).hasClass("pop_up_confirm")){
        defaultConfirm();
    }
};

var defaultConfirm = function(){
    var popup = $(".pop_up_confirm");
    popup.removeClass("h__PopupDisplayFlex");
    popup.find(".title").show();
    btn_yes_action = function(){console.log("no_action")};
};

var openPopupImg = function(src, title, info){
    var popup = $(".pop_up_confirm.popup__img");
    popup.find("img").attr('src', src);
    if (title == undefined){
        popup.find(".title").hide();
    }else{
        popup.find(".title").text(title);
        if (info != undefined) popup.find(".title").append($("<p>" + info + "</p>"))
    }
    popup.addClass("h__PopupDisplayFlex");
};

var openPopupImgBtn = function(){
    var btn = $(this);
    openPopupImg(btn.attr('src'));
    var elemPluso = document.querySelectorAll("div.pluso")[0];
    elemPluso.pluso.params.url = current_domain() + "/course_description?id=" + btn.data('course_id');
    elemPluso.pluso.params.image = current_domain() + btn.attr('src');
    elemPluso.pluso.params.title = "Я получил сертефикат";
    elemPluso.pluso.params.description = btn.data('course_name');
};

$(document).ready(function () {
    $(document).on('click', '.pop_up_confirm', closePopupConfirm);
    $(document).on('click', '.js_openPopupImgBtn', openPopupImgBtn);
    $(document).on('click', '.pop_up_confirm .action-btn .js_closePopupConfirmNo', defaultConfirm);
    $(document).on('click', '.pop_up_confirm .action-btn .js_actionYesStart', function(){
        btn_yes_action();
        defaultConfirm();
    });
});

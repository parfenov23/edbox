var btn_yes_action = function(){};

function confirm(text, action){
    var popup = $(".pop_up_confirm");
    popup.find(".inner .description").text(text);
    btn_yes_action = action;
    popup.show();
}

function warning(text, actionText){
    var popup = $('.pop_up_confirm');
    popup.find('.inner .description').text(text);
    popup.find('.action-btn .js_closePopupConfirmNo').attr('style', 'display:none');
    popup.find('.action-btn .js_actionYesStart').text(actionText);
    btn_yes_action = defaultConfirm;
    popup.show();
}

//var closePopupConfirm = function (event) {
//    var evt = evt || event;
//    var target = evt.target || evt.srcElement;
//    if ($(target).closest(".pop_up_confirm").length == 0 || $(target).hasClass("js_closePopupConfirmNo") > 0 || $(target).hasClass("pop_up_confirm") > 0){
//        defaultConfirm();
//    }
//};

var defaultConfirm = function(){
    var popup = $(".pop_up_confirm");
    popup.hide();
    btn_yes_action = function(){console.log("no_action")};
};

$(document).ready(function () {
    $(document).on('click', '.pop_up_confirm, .pop_up_confirm .action-btn .js_closePopupConfirmNo', defaultConfirm);
    $(document).on('click', '.pop_up_confirm .action-btn .js_actionYesStart', function(){
        btn_yes_action();
        defaultConfirm();
    });
});

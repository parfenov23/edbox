var btn_yes_action = function(){};

function confirm(text, action){
    var popup = $(".pop_up_confirm");
    popup.find(".inner .description").text(text);
    btn_yes_action = action;
    popup.show();
}
var closePopupConfirm = function () {
    var evt = evt || event;
    var target = evt.target || evt.srcElement;
    if ($(target).closest(".pop_up_confirm").length == 0 || $(target).hasClass("cancel") > 0 || $(target).hasClass("pop_up_confirm") > 0){
        defoultConfirm();
    }
};

var defoultConfirm = function(){
    var popup = $(".pop_up_confirm");
    popup.hide();
    btn_yes_action = function(){console.log("no_action")};
};

$(document).ready(function () {
    $(document).on('click', '.pop_up_confirm, .pop_up_confirm .action-btn .btn.cancel', closePopupConfirm);
    $(document).on('click', '.pop_up_confirm .action-btn .btn.yes', function(){
        btn_yes_action();
        defoultConfirm();
    });
});
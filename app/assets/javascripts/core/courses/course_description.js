var openHiddenList = function (e) {
    e.preventDefault();
    if ($(e.target).hasClass("js_openHiddenList")){
        $(this).find(".block_hidden_list").show();
    }
    $(this).find(".ripple-wrapper").remove();
};

var closeHiddenList = function () {
    $(this).closest(".block_hidden_list").hide();
};

pageLoad(function () {
    $(document).on('click', '.js_openHiddenList', openHiddenList);
    $(document).on('click', '.js_openHiddenList .block_hidden_list li', closeHiddenList);
});
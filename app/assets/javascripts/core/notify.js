var notifyMyWeb = function (hashParams) {
    var notification = $(".notification.parent_notify");
    var new_notify = notification.clone().removeClass("parent_notify").addClass("child_notify");
    var all_child_notify = $(".notification.child_notify");
    var top = 140 * all_child_notify.length;
    new_notify.css("top", top);
    $("body").append(new_notify);
    childNotifyContent(new_notify, hashParams);
    setTimeout(function(){
        new_notify.addClass("open");
    }, 100);

    // Close Notify
    if (hashParams.timeClose > 0){
        setTimeout(function () {
            childNotifyClose(new_notify);
        }, hashParams.timeClose)
    }
};

var childNotifyContent = function(notify, hashParams){
    if (hashParams.title) notify.find(".notify_content .title").html(hashParams.title);
    if (hashParams.description) notify.find(".notify_content .description").html(hashParams.description);
    if (typeof hashParams.onClose == "function"){
        notify.find(".notify_content .close").click(hashParams.onClose);
    }
    if (typeof hashParams.onClick == "function"){
        notify.find(".notify_content .description").click(hashParams.onClick);
    }
    if (hashParams.img) notify.find(".img img").attr("src", hashParams.img);
};

var childNotifyUpdate = function(){
    var childNotify = $(".notification.child_notify");
    $.each(childNotify, function(i, block){
        var top = 140 * i;
        $(block).css("top", top);
    })
};

var childNotifyClose = function(notify){
    notify.removeClass("open");
    setTimeout(function () {
        notify.remove();
        childNotifyUpdate();
    }, 300);
};

$(document).on('click', ".notification.child_notify .notify_content .close", function(){
    var btn = $(this);
    var notify = btn.closest(".notification");
    childNotifyClose(notify);
});
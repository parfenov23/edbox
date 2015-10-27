var view_px_block = function (block) {
    var win_height = $(window).height();
    var curr_pos = block.position().top;
    var curr_scroll = $(document.body).scrollTop();
    var accessing_top = parseInt(block.css("margin-top")) + parseInt(block.css("padding-top"));

    var do_block = win_height + curr_scroll - (curr_pos + 64 + accessing_top);
    return do_block
};

pageLoad(function(){
    var back_item_link = $("a.item[href='backCourse']")
    if (back_item_link.length){
        back_item_link.attr('href', back_url('find', ["courses", 'cabinet']))

    }
});
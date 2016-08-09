function clearFileInputField(id) {
    var el = $("#" + id);
    var el_html = el.prop('outerHTML');
    var el_parent = el.parent();
    el.remove();
    el_parent.append($(el_html));
}

var view_px_block = function (block) {
    var win_height = $(window).height();
    var curr_pos = block.position().top;
    var curr_scroll = $(document.body).scrollTop();
    var accessing_top = parseInt(block.css("margin-top")) + parseInt(block.css("padding-top"));

    var do_block = win_height + curr_scroll - (curr_pos + 64 + accessing_top);
    return do_block
};

var rightFilterShowSubsidiary = function(){
    var btn = $(this);
    var block = btn.closest(".parent_tag").find("ul:first");
    if (block.is(":visible")){
        btn.closest(".parent_tag").removeClass("open");
        block.hide();
    }else{
        btn.closest(".parent_tag").addClass("open");
        block.show();
    }

};

var searchFilterTagFind = function(){
    var btn = $(this);
    window.location.href = '/courses?tid=' + btn.data('id');
};

pageLoad(function () {
    var back_item_link = $("a.item[href='backCourse']")
    if (back_item_link.length){
        back_item_link.attr('href', back_url('find', ["courses", 'cabinet']))

    }
    $(document).on('click', '#js-filter-courses .parentTreeUl .parent_tag .title', rightFilterShowSubsidiary);
    $(document).on('click', '.last_subtag .js__searchFilterTagFind', searchFilterTagFind);
});
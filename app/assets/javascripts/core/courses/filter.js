var closeFilterGroup = function(){
    $("#js-filter-courses").removeClass("show");
};

$(document).ready(function(){
    $(document).on('click', '#js-filter-courses .close-filter', closeFilterGroup);
});
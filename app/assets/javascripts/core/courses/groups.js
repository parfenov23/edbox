var closeAsideGroup = function(){
    $("#js-groups-courses").removeClass("show");
};

$(document).ready(function(){
    $(document).on('click', '#js-groups-courses .close-filter', closeAsideGroup);
});
var addFavorite = function () {
    var btn = $(this);
    var course_id = btn.data("id");
    $.ajax({
        type: 'POST',
        url : '/api/v1/users/add_favorite_course',
        data: {course_id: course_id}
    }).success(function (data) {
        if (data.success){
            show_error('Курс добавлен в избранные курсы', 3000);
        }else{
            show_error('Курс уже добавлен в избранные курсы', 3000);
        }
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
    return true;
};

var removeFavorite = function () {
    var btn = $(this);
    var favorite_course_id = btn.data("id");
    $.ajax({
        type: 'POST',
        url : '/api/v1/users/remove_favorite_course',
        data: {favorite_course_id: favorite_course_id}
    }).success(function () {
        btn.closest(".favorite-item").remove();
        show_error('Курс удален из избранного', 3000);
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
    return true;
};

var closeAsideFavorite = function(){
    $("#js-favorite-courses").removeClass("show");
};

$(document).ready(function () {
    $(document).on('click', '.corses-prev .action-btn .favorite, ' +
        '.courses-description .text-block .action-block .add-to-fav', addFavorite);
    $(document).on('click', '.favorite-item .header .delete, .js_removeFavorite', removeFavorite);
    $(document).on('click', '#js-favorite-courses .close-filter', closeAsideFavorite);
});
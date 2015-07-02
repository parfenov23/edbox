var addFavorite = function () {
    var btn = $(this);
    var course_id = btn.data("id");
    $.ajax({
        type: 'POST',
        url : '/api/v1/users/add_favorite_course',
        data: {course_id: course_id}
    }).success(function () {
        show_error('Курс добавлен в избранное', 3000);
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


$(document).ready(function () {
    $(document).on('click', '.corses-prev .action-btn .favorite', addFavorite);
    $(document).on('click', '.favorite-item .header .delete', removeFavorite);
});
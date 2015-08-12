var js_onChangeEditCourse = function () {
    var input = $(this);
    var form = input.closest("form");
    var input_id = formInputIdCourse();
    var id_course = input_id.val();
    if (id_course == "new"){
        createCourseContenter(form.serialize());
    } else {
        updateCourseContenter(form.serialize(), id_course);
    }
};

var createCourseContenter = function (data) {
    $.ajax({
        type: 'POST',
        url : '/api/v1/courses/',
        data: data
    }).success(function (data) {
        var input_id = formInputIdCourse();
        input_id.val(data.id);
        history.pushState({}, '', "/contenter/courses/" + data.id + "/edit");
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
    return true;
};

var formInputIdCourse = function () {
    var form = $('.js_courseContenter');
    var input_id = form.find("input[name='course[id]']");
    return input_id
};

var updateCourseContenter = function (data, id) {
    $.ajax({
        type: 'PUT',
        url : '/api/v1/courses/' + id,
        data: data
    }).success(function (data) {
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
    return true;
};

var contenterAddTagToCourse = function () {
    var btn = $(this);
    if (! btn.hasClass("active")){
        btn.addClass("active");
        addBunchTagFromCourse(btn.data("id"), courseLoadTags);
    }
};
var addBunchTagFromCourse = function (id, action) {
    var input_id = formInputIdCourse();
    if (input_id.val() != "new"){
        $.ajax({
            type: 'POST',
            url : '/api/v1/courses/' + input_id.val() + "/add_tag",
            data: {tag_id: id}
        }).success(function (data) {
            action(data);
        }).error(function () {
            show_error('Произошла ошибка', 3000);
        });
        return true;
    } else {
        show_error('Произошла ошибка', 3000);
    }
};

var removeBunchTagFromCourse = function () {
    var input_id = formInputIdCourse();
    var btn = $(this);
    $.ajax({
        type: 'POST',
        url : '/api/v1/courses/' + input_id.val() + "/remove_tag",
        data: {tag_id: btn.data("id")}
    }).success(function (data) {
        btn.closest(".tag").remove();
        $("#js-course-tags .all__Tags .tag[data-id=" + data.id + "]").removeClass("active");
    }).error(function () {
        show_error('Произошла ошибка', 3000);
    });
};

var courseLoadTags = function (data) {
    var block_tags = $(".itemDetailInfo .description__Item .allTagDescriptionCourse");
    var html = $('<div class="tag">' + data.title +
        '<div class="remove js_removeBunchTagFromCourse" data-id="' + data.id + '"></div>' +
        '</div>')
    block_tags.append(html);
};

pageLoad(function () {
    $('.js_courseContenter .js_onChangeEditCourse').change(js_onChangeEditCourse);
    $(document).on('click', ".js_courseContenter .js_clickFromCreateCourseContenter", js_onChangeEditCourse);
    $(document).on('click', ".js__contenterAddTagToCourse", contenterAddTagToCourse);
    $(document).on('click', ".allTagDescriptionCourse .js_removeBunchTagFromCourse", removeBunchTagFromCourse);
    $(document).on('click', ".courses-aside .close-filter", function () {
        $(this).closest(".courses-aside").removeClass("show");
    });
});
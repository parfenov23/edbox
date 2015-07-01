//= require ./jquery-2.1.3.min
//= require ./vendor/jquery-ui.min
//= require ./vendor/jquery.cookie
//= require ./vendor/__underscore
//= require ./vendor/_backbone
//= require ./vendor/marionette
//= require ./vendor/material
//= require ./vendor/ripples
//= require ./vendor/zbaron.min
//= require skim


//= require_tree ./backbone_app/templates
//= require_tree ./backbone_app/config
//= require backbone_app/app
//= require_tree ./backbone_app/models
//= require_tree ./backbone_app/init
//= require_tree ./backbone_app/tools
//= require_tree ./backbone_app/views
//= require_tree ./backbone_app/routers

$(document).ajaxSend(function (event, jqxhr, settings) {
    jqxhr.setRequestHeader('USER-KEY', $.cookie('user_key'));
});




$(document).ready(function(){

  $('#js-add-course-to-shedule .select-trigger').on('click', function () {
    $(this).closest('.select').find('ul.hidden').show();
  })

  $('body').on('click', function (e) {
    var list;
    $(document).trigger('click.dropdown');
    list = $(e.target).closest('.select').find('ul.hidden').show();
    $(document).bind('click.dropdown', function(ev) {
      if (e.target !== ev.target) {
        list.hide();
        return $(document).unbind('click.dropdown');
      }
    });
  })

  $('.filter-category .more .icon').on('click', function () {
    $(this).closest('.more').removeClass('hidden');
  })


  $('.header__bottom .aside-trigger').on('click', function () {
    var id = $(this).data('id');
    if ($('#'+ id +'').hasClass('show')) {
      $('#'+ id +'').toggleClass('show');
    }
    else {
      $('.courses-aside:visible').removeClass('show');
      $('#'+ id +'').toggleClass('show');
    }
  })

  $('#js-add-course-to-shedule .datapicker__trigger').datepicker({
    prevText: '&#x3c;Пред',
    nextText: 'След&#x3e;',
    currentText: 'Сегодня',
    monthNames: ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'],
    monthNamesShort: ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн', 'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек'],
    dayNames: ['воскресенье', 'понедельник', 'вторник', 'среда', 'четверг', 'пятница', 'суббота'],
    dayNamesShort: ['вск', 'пнд', 'втр', 'срд', 'чтв', 'птн', 'сбт'],
    dayNamesMin: ['Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб'],
    dateFormat: 'dd.mm.yy',
    firstDay: 1,
    isRTL: false,
    beforeShow: function() {
      return $('#ui-datepicker-div').addClass('hide');
    },
    onSelect: function() {
      return $(this).parent().addClass('show');
    }
  });

  $('#js-add-course-to-shedule .datapicker__trigger').on('click', function ()  {
    $('#ui-datepicker-div').removeClass('hide');
  });

  figcaptionTitleEclipses = function ( el, height) {
    var heights = [];
    $(el).each(function(indx, element){
      if ($(element).height()> height) {
        $(element).addClass('over-title')
      }
    });
  }

  $('.filter-courses').baron();

  headerTabsLine = function(){
    var width = $('.tabs__item.active').outerWidth();
    $('.header__bottom .tabs .line').css({'width':width+'px'});
  }

  setTimeout(function(){
    headerTabsLine();
  },10);

  profileDataChange = function(){
    $('.profile__main #submit').click(function(){
      var data = $('.profile__main').serialize();
      $.ajax({
        type: 'POST',
        url: '/api/v1/users',
        data: data
      }).success(function(){
          console.log('Ушло');
      }).error(function(){
          console.log('Не ушло');
      });
    });
  }

  profilePasswordChangeValidation = function(){
    $('#profile input').blur(function(){
      var pass = $('#profile input[name=password]').val();
      var pass_repeat = $('#profile input[name=password_repeat]').val();
      if (pass == pass_repeat){
        $('#profile input[name=password_repeat]').removeClass('error');
      }
      else {
        $('#profile input[name=password_repeat]').addClass('error');
      }
    });
  }

  profilePasswordChange = function(){
    $('.profile__password #submit').click(function(){
      var data = $('.profile__password input[name=password]').serialize();
      $.ajax({
        type: 'POST',
        url: '/api/v1/users/change_password',
        data: data
      }).success(function(){
          console.log('Ушло');
      }).error(function(){
          console.log('Не ушло');
      });
    });
  }

  profileDataChange();
  profilePasswordChangeValidation();
  profilePasswordChange();
  figcaptionTitleEclipses('.corses-prev figcaption .title', 84);
  figcaptionTitleEclipses('.favorite-item .description .title', 56);




});

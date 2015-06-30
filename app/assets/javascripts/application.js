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


  show_error = function(text, duration){
    var el = $('#alert');
    el.find('.text').text(text);
    el.show(300);
    el.find('.close').click(function(){
      el.hide(400);
    });
    setTimeout(function(){
      el.hide(400);
    }, duration);
  }

  setTimeout(function(){
    var windowHeight = $(window).outerHeight();
    $('.auth').css({'height':windowHeight+'px'});
  } , 100);



  $('.header__bottom .settings .icon, #js-filter-courses .close-filter').on ('click', function () {
    $('#js-filter-courses').toggleClass('show');
  })

  $('.filter-courses').baron();

  headerTabsLine = function(){
    var width = $('.tabs__item.active').outerWidth();
    var offset = $('.tabs__item.active').position().left;
    $('.header__bottom .tabs .line').css({'width':width+'px','left':offset+'px'});
  }

  setTimeout(function(){
    headerTabsLine();
  },100);

  profileDataChange = function(){
    $('.profile__main #submit').click(function(){
      var data = $('.profile__main').serialize();
      $.ajax({
        type: 'POST',
        url: '/api/v1/users',
        data: data
      }).success(function(){
        console.log('111');
        show_error('Успешно сохранено', 3000);
      }).error(function(){
        console.log('111');
        show_error('Ошибка', 3000);
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
          show_error('Успешно сохранено', 3000);
      }).error(function(){
          show_error('Ошибка', 3000);
      });
    });
  }





  invitedEmpty = function(){
    if ($('.invited__item').length == 0) {
      $('.members__invite .invited').hide();
    }
  }

  invitedMemberDelete = function(){
    $(document).on('click', '.members__invite .cancel', function(){
      console.log($(this));
      console.log($(this).closest('.invited__item'));
      $(this).closest('.invited__item').remove();
      invitedEmpty();
    });
  }

  inviteMember = function(){
    var emailRegexp = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
    $('.members__invite .input').focus(function(){
      $(window).keydown(function(e){
        code = e.keyCode || e.which
        if ( code == 13 ) {
          e.preventDefault();
          var member = $('.members__invite .input').val();
          if(emailRegexp.test(member) == false) {
            alert('Неправильный email');
          }
          else {
            $('.members__invite .invited').show();
            $('<li class="invited__item"><div class="email">'+member+'</div><div class="cancel">×</div></li>').appendTo('.members__invite .invited');
          }
        }
      });
    });
  }

  sendInvintations = function(){
    $('.members__invite .plane').click(function(){
      if (!$('.invited__item').length == 0) {
        var data = $.map($('.members__invite .invited__item .email'), function(el){
          return $(el).text();
        });
        $.ajax({
          type: 'POST',
          url: '/api/v1/users/invite',
          data: {emails:data},
        }).success(function(){
            console.log('Ушло');
            location.reload();
        }).error(function(){
            console.log('Не ушло');
        });
      }
    });
  }



  deleteInvitedMember = function(){
    $('.members__in_system .members__in_system-item .delete').click(function(){
      var number = $(this).attr('data-id');
      $(this).closest('.members__in_system-item').remove();
      $.ajax({
        type: 'POST',
        url: '/api/v1/users/remove_user',
        data: {id:number},
      }).success(function(){
          console.log('Ушло');
      }).error(function(){
          console.log('Не ушло');
      });
    });
  }


  headerUserToggle = function(){
    $(document).on('click', function(e){
      if ( $(e.target).closest('.header__user').length == 0 ) {
        $('.menu__user').removeClass('active');
      }
      else if ( $(e.target).closest('.header__user').length == 1 ) {
        if ( $(e.target)[0].className == 'ava' ) {
         $('.menu__user').toggleClass('active');
        }
        else {
          $('.menu__user').addClass('active');
        }
      }
    });
  }

  changeAvatar = function(e){
    var data = new FormData();
    data.append('ava', $('input[type=file]')[0].files[0]);
    $.ajax({
        type: 'POST',
        url: '/api/v1/users/update_avatar',
        data: data,
        cache: false,
        contentType: false,
        processData: false,
      }).success(function(){
          $('.profile__main .ava').attr('src', 'data:image/png;base64,' + data.base64);
          show_error('Ваш новый аватар готов', 3000);
      }).error(function(){
          show_error('Не удалось обновить аватар', 3000);
      });
  }



  profileDataChange();
  profilePasswordChangeValidation();
  profilePasswordChange();


  invitedEmpty();
  invitedMemberDelete();
  inviteMember();
  sendInvintations();
  deleteInvitedMember();

  headerUserToggle();

  changeAvatar();

});

//= require ./jquery-2.1.3.min
//= require ./vendor/jquery-ui.min
//= require ./vendor/jquery.cookie
//= require ./vendor/__underscore
//= require ./vendor/_backbone
//= require ./vendor/marionette
//= require ./vendor/material
//= require ./vendor/ripples
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

  headerTabsLine = function(){
    var width = $('.tabs__item.active').outerWidth();
    $('.header__bottom .tabs .line').css({'width':width+'px'});
  }

  setTimeout(function(){
    headerTabsLine();
  },10);

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

  }

  profilePasswordChangeValidation();
  profilePasswordChange();




});

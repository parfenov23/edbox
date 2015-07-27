//var bind = function (fn, me) { return function () { return fn.apply(me, arguments); }; };
//
//var WebSocket = function (url, useWebSockets) {
//    this.newNotif = bind(this.newNotif, this);
//    this.dispatcher = new WebSocketRails(url, useWebSockets);
//    this.dispatcher.on_open = this.createGuestUser;
//};
//
//WebSocket.prototype.Controller = function(){
//
//};
//
//jQuery(function () {
//    return window.websocket = new WebSocket($('body').data('uri'), true);
//});
//==========

(function() {
    var bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

    jQuery(function() {
        return window.websocketController = new Websocket.Controller($('body').data('uri'), true);
    });

    window.Websocket = {};

    Websocket.User = (function() {
        function User(user_name) {
            this.user_name = user_name;
            this.serialize = bind(this.serialize, this);
        }

        User.prototype.serialize = function() {
            return {
                user_name: this.user_name
            };
        };
        return User;
    })();


    Websocket.Controller = (function() {
        function Controller(url, useWebSockets) {
            this.bindEvents = bind(this.bindEvents, this);
            this.dispatcher = new WebSocketRails(url, useWebSockets);
            console.log(1)
            this.dispatcher.on_open = this.createGuestUser;
            this.updateUserList = bind(this.updateUserList, this);

        }

        Controller.prototype.updateUserList = function(userList) {
            console.log(userList);
        };

        Controller.prototype.createGuestUser = function() {
            var rand_num;
            rand_num = Math.floor(Math.random() * 1000);
            this.user = new Websocket.User("Guest_" + rand_num);
            console.log(this.user);
            console.log(this.dispatcher)
            return this.dispatcher.trigger('new_user', this.user.serialize());
        };

        return Controller;

    })();

}).call(this);
;

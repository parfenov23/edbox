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
            this.dispatcher.on_open = this.createGuestUser;
            this.updateUserList = bind(this.updateUserList, this);
            this.bindEvents();
        }

        Controller.prototype.updateUserList = function(userList) {
            console.log(userList);
        };

        Controller.prototype.createGuestUser = function() {
            var rand_num;
            rand_num = Math.floor(Math.random() * 1000);
            this.user = new Websocket.User("Guest_" + rand_num);
            console.log(this.user);
            return this.trigger('new_user', this.user.serialize());
        };

        Controller.prototype.bindEvents = function() {
            this.dispatcher.bind('user_list', this.updateUserList);
        };

        return Controller;

    })();

}).call(this);
;

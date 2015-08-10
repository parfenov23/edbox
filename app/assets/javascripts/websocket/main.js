if ($.cookie('user_key') != undefined){
    (function () {
        var bind = function (fn, me) { return function () { return fn.apply(me, arguments); }; };

        jQuery(function () {
            return window.websocketController = new Websocket.Controller($('body').data('uri'), true);
        });

        window.Websocket = {};

        Websocket.User = (function () {
            function User(user_name) {
                this.user_name = user_name;
                this.serialize = bind(this.serialize, this);
            }

            User.prototype.serialize = function () {
                return {
                    user_name: this.user_name
                };
            };
            return User;
        })();

        Websocket.Controller = (function () {
            function Controller(url, useWebSockets) {
                this.bindEvents = bind(this.bindEvents, this); // вызов всех биндов
                this.dispatcher = new WebSocketRails(url, useWebSockets);
                this.dispatcher.on_open = this.createGuestUser;
                this.updateUserList = bind(this.updateUserList, this);
                this.notification = bind(this.notification, this);
                this.consoleAlert = bind(this.consoleAlert, this); // После bind идет вызов метода
                this.bindEvents();
            }

            // Binds ===========================
            Controller.prototype.bindEvents = function () {
                this.dispatcher.bind('user_list', this.updateUserList);
                this.dispatcher.bind('alert', this.consoleAlert); // метод на отлов действия с сервера
                var user_channel = this.dispatcher.subscribe($.cookie('user_key'));
                user_channel.bind("notification", this.notification);
            };

            Controller.prototype.notification = function (message) { // Уведомления
                message = JSON.parse(message);
                notifyMyWeb({
                    timeClose: message.timeClose,
                    title: message.title,
                    description: message.body,
                    onClose: function(){console.log("close")},
                    onClick: function(){
                        childNotifyClose( $(this).closest(".notification") );
                        if (message.linkGo) window.location.href = message.linkGo
                    }
                });
                //notifyMypush({title: message.title, body: message.body})
            };
            //==================================

            // Triggers ========================
            Controller.prototype.createGuestUser = function () {
                this.user = new Websocket.User($.cookie('user_key'));
                var result = this.trigger('new_user', this.user.serialize()); // метод на отправку зопроса серверу
                $("#testWebsocketJs").text($.cookie('user_key'));
                return result;
            };
            //=================================

            Controller.prototype.updateUserList = function (userList) {
                console.log(userList);
            };

            Controller.prototype.updateUserList = function (userList) {
                //console.log(userList);
            };

            Controller.prototype.consoleAlert = function (txt_alert) { // вызов функции после bind
                //console.log(txt_alert);
            };


            return Controller;

        })
        ();

    }).call(this);
    ;
}
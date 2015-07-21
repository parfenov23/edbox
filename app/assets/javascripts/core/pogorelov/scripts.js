jQuery(document).ready(function() {
    //debugger
    // Resize textarea by keyup
    var textareaResize = $("textarea.expand");
    if(textareaResize.length) {
         $(textareaResize).TextAreaExpander();
    }

    // Modal init
    ModalWindow.init({onShow: scrollInit});


    // $(".date" ).datepicker({
    //   changeMonth: true,
    //   changeYear: true
    // });

});


// Modal window

function ModalWindow() {
    var self = this;

    self.activeModal = null;

    self.init = function(options){              //options: onShow, onHide are callbacks
        this.overlay    = $('.md-overlay');
        this.trigger    = $('.md-trigger');
        this.close      = $('.md-close');
        onShow = options ? options.onShow : null;
        onHide = options ? options.onHide : null;
        //remove old events
        this.overlay.unbind('click.modal');
        this.close.unbind('click.modal');
        this.trigger.unbind('click.modal');
        //init events
       /* this.overlay.bind('click.modal', function(e){
            e.preventDefault();
            self.hideModalWindow(onHide);
        });*/
        this.close.bind('click.modal', function(e){
            e.preventDefault();
            self.hideModalWindow(onHide);
        });
        this.trigger.bind('click.modal', function(e){
            e.preventDefault();
            this.attrID = $(this).attr('href');
            self.showModalWindow(this.attrID, onShow);
        });

    };

    self.showModalWindow = function(id, callback){
        self.activeModal = $(id);
        self.activeModal.toggleClass('md-show');
        if(typeof callback == 'function'){
            callback();
        }
    };

    self.hideModalWindow = function(callback){
        self.activeModal.toggleClass('md-show');
        if(typeof callback == 'function'){
            callback();
        }
        self.activeModal = null;

    };
}

var ModalWindow = new ModalWindow();

function scrollInit() {
    $('.scrollbar-outer, .textarea-scrollbar').scrollbar({
        ignoreOverlay: false
    });
    $('.md-content .single-course').click(function(){
        if ($(this).hasClass('selected')) {
            $(this).removeClass('selected');
        } else {
            $(this).addClass('selected');
        };
    });
}

window.onload = function() {
    var heart = document.getElementsByClassName("heart");
    var classname = document.getElementsByClassName("tabitem");
    var boxitem = document.getElementsByClassName("box");

    var clickFunction = function(e) {
        e.preventDefault();
        var a = this.getElementsByTagName("a")[0];
        var span = this.getElementsByTagName("span")[0];
        var href = a.getAttribute("href").replace("#","");
        for(var i=0;i<boxitem.length;i++){
            boxitem[i].className =  boxitem[i].className.replace(/(?:^|\s)show(?!\S)/g, '');
        }
        document.getElementById(href).className += " show";
        for(var i=0;i<classname.length;i++){
            classname[i].className =  classname[i].className.replace(/(?:^|\s)active(?!\S)/g, '');
        }
        this.className += " active";
        span.className += 'active';
        var left = a.getBoundingClientRect().left;
        var top = a.getBoundingClientRect().top;
        var consx = (e.clientX - left);
        var consy = (e.clientY - top);
        span.style.top = consy+"px";
        span.style.left = consx+"px";
        span.className = 'clicked';
        span.addEventListener('webkitAnimationEnd', function(event){
            this.className = '';
        }, false);
    };

    for(var i=0;i<classname.length;i++){
        classname[i].addEventListener('click', clickFunction, false);
    }
    for(var i=0;i<heart.length;i++){
        heart[i].addEventListener('click', function(e) {
            var classString = this.className, nameIndex = classString.indexOf("active");
            if (nameIndex == -1) {
                classString += ' ' + "active";
            }
            else {
                classString = classString.substr(0, nameIndex) + classString.substr(nameIndex+"active".length);
            }
            this.className = classString;

        }, false);
    }
}

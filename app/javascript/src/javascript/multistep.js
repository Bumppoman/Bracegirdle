window.animating = false;
window.nextItem = function (fieldset, animate = true) {
    if (animate == true) {
        if (window.animating) return false;
        window.animating = true;
    }

    let current_fs = fieldset, next_fs = fieldset.next();

    $(".progressbar li").eq($("fieldset").index(next_fs)).addClass("active");

    next_fs.show();

    if (animate == true) {
        current_fs.animate({
            opacity: 0
        }, {
            step: function (now, mx) {
                let scale = 1 - (1 - now) * 0.2, left = (now * 50) + "%", opacity = 1 - now;
                current_fs.css({ 'transform': 'scale(' + scale + ')' });

                next_fs.css({
                    'left': left,
                    'opacity': opacity
                });
            },
            duration: 800,
            easing: 'easeInOutBack',
            complete: function () {
                current_fs.hide();
                window.animating = false;
            }
        });
    } else {
        current_fs.hide();
    }
}

    /*previousItem = (fieldset) ->
    #    if (animating) return false;
    #    animating = true;
    #
    #    current_fs = fieldset
    #    previous_fs = fieldset.prev();

    #    //de-activate current step on progressbar
    #    $("#progressbar li").eq($("fieldset").index(current_fs)).removeClass("active");

    #    //show the previous fieldset
    #    previous_fs.show();

    #    //hide the current fieldset with style
    #    current_fs.animate({
    #        opacity: 0
    #    }, {
    #        step: function (now, mx) {
    #            //as the opacity of current_fs reduces to 0 - stored in "now"
    #            //1. scale previous_fs from 80% to 100%
    #            scale = 0.8 + (1 - now) * 0.2;
    #            //2. take current_fs to the right(50%) - from 0%
    #            left = ((1 - now) * 50) + "%";
    #            //3. increase opacity of previous_fs to 1 as it moves in
    #            opacity = 1 - now;
    #            current_fs.css({
    #                'left': left
    #            });
    #            previous_fs.css({
    #                'transform': 'scale(' + scale + ')',
    #                'opacity': opacity
    #            });
    #        },
    #        duration: 800,
    #        complete: function () {
    #            current_fs.hide();
    #            animating = false;
    #        },
    #        //this comes from the custom easing plugin
    #        easing: 'easeInOutBack'
    #    });
    #}*/
// $B8=:_%Z!<%8$,4^$^$l$k%"%3!<%G%#%*%s%a%K%e!<$r3+$/(B
// $B%[%s%H$O%l%s%@%j%s%0;~$K%9%?%$%k;XDj$7$F$*$-$?$$$s$@$1$I(B
// ruhoh $B$N;EAH$_$G$O=PMh$J$=$&$@$C$?$N$G8e=hM}$G4hD%$k(B

var AccordionOpener = {
    openCurrent: function(selector) {
        selector = selector || '.accordion-body';
        $(selector).each(function() {
            if ($(this).find('.active-page').size()) {
                $(this).addClass('in');
            }
        });
    }
};

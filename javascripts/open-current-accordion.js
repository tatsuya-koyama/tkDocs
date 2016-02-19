// 現在ページが含まれるアコーディオンメニューを開く
// ホントはレンダリング時にスタイル指定しておきたいんだけど
// ruhoh の仕組みでは出来なそうだったので後処理で頑張る

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

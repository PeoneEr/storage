/* This is a manifest file that'll be compiled into including all the files listed below.
 * Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
 * be included in the compiled file accessible from http://example.com/assets/application.js
 * It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
 * the compiled file.
 *
 *= require jquery
 *= require jquery-ui
 *= require elfinder.js
 *= require i18n/elfinder.ru.js
 */
$(function() {
  $('#elfinder').elfinder({
    lang: 'ru',
    height: '600',
    uiOptions : {
      toolbar : [
        ['home', 'up'],
        ['back', 'forward'],
        ['reload'],
        ['mkdir', 'mkfile', 'upload'],
        ['open', 'download'],
        ['info'],
        ['quicklook'],
        ['copy', 'cut', 'paste'],
        ['rm'],
        ['duplicate', 'rename', 'edit'],
        ['view'],
        ['help']
      ]
    },
    url: '/api/el_finder/v2'
  });
});

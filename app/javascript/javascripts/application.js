import I18n from 'src/i18n-js/index.js.erb'
window.$ = require('jquery');
$('#user_image').bind('change', function() {
  var size_in_megabytes = this.files[0].size/1024/1024;
  if (size_in_megabytes > 5) {
    alert(I18n.t('errors.messages.size_range', {locale: "ja"}));
  }
});
$(function(){
  setTimeout(function(){
    setTimeout(function(){
      $('.flash-message .alert').addClass("zindex-minus");
    },3000);
    $('.flash-message .alert').addClass("animated fadeOutUp");
  },3000);
});

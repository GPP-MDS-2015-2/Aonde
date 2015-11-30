(function($){
  $(document).ready(function(){
    $('.parallax').parallax();
  });
})(jQuery);

(function($){
  $(document).ready(function(){
      $('.modal-trigger').leanModal();
      $('.button-collapse').sideNav();
      $('select').material_select();
      $('.tooltipped').tooltip({delay: 50});
  });
})(jQuery);

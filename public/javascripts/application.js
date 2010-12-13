var searchTimer = null;
$(document).ready(function () {
  $('#ownership_users_search').keydown(function () {
    if ($(this).val().length > 2) {
      var form = $(this).parents("form");
      
      if (searchTimer) {
        clearTimeout(searchTimer);
        searchTimer = null;
      }
      
      searchTimer = setTimeout(function (argument) {
        $("#users_right").load(form.attr("action") + "?format=js&" + form.serialize());
      }, 500);
      
    }
    
  });
  
  $("#users_right li a").live("click", function () {
    $(this).fadeOut();
    var form = $(this).parents("form");
    var id = $(this).parents("li").attr("data-id");
    
    $.ajax({
      type: "POST",
      url: form.attr("action"),
      data: form.serialize() + "&user_id=" + id,
      dataType: "html",
      success: function(html){
        $('#users_left').append(html);
      },
    })
    
    return false;
  });
  
  $("#users_left li a").live("click", function () {
    $(this).fadeOut();
    var id = $(this).parents("li").attr("data-id");
    
    $.ajax({
      type: "POST",
      url: $(this).attr("href"),
      data: "_method=delete",
      dataType: "html",
      success: function(html){
        $('#users_right').append(html);
      },
    })
    
    return false;
  });
  
  $('#category_color').ColorPicker({
  	onSubmit: function(hsb, hex, rgb, el) {
  		$(el).val("#"+hex);
  		$(el).ColorPickerHide();
  	},
  	onBeforeShow: function () {
  		$(this).ColorPickerSetColor(this.value);
  	},
  	onChange: function (hsb, hex, rgb) {
      $('#category_color').val("#"+hex);
    }
  }).bind('keyup', function(){
  	$(this).ColorPickerSetColor(this.value);
  });
  
  $('#new_comment').submit(function () {
    $('.comment_ajax_loader').fadeIn();
    
    $.ajax({
      url: $(this).attr("action"),
      type: "POST",
      data: $(this).serialize(),
      dataType: "script",
      success: function(){
        $('#new_comment')[0].reset();
        $('.comment_ajax_loader').fadeOut();
      },
    });
    return false;
  });
});
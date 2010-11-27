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
});
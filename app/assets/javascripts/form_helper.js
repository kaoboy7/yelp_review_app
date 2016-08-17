function addDescriptionGroup() {
  $('#dish-group').clone().removeAttr('id').insertAfter('#dish-group')
}

function copyToClipboard(element) {
  var $temp = $("<input>");
  $("body").append($temp);
  $temp.val($('#' + element).text()).select();
  document.execCommand("copy");
  $temp.remove();
}
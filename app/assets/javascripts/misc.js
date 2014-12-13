function toggle_checkall(state) {
  var checkboxes = document.getElementsByTagName('input');
  var count = checkboxes.length;
  for (var i = 0; i < count; i++) {
    if (checkboxes[i].type == "checkbox"
        && (checkboxes[i].name == "id[]" || checkboxes[i].name == "folders_id[]")) {
      checkboxes[i].checked = state;
    }
  }
  check_click();
}

function check_click() {
  var checkboxes = document.getElementsByTagName('input');
  var count = checkboxes.length;
  var flag = false;
  for (var i = 0; i < count; i++) {
    if (checkboxes[i].className == "chkbox" && checkboxes[i].checked) {
        flag = true;
        break;
    }
  }
  if (flag) {
    document.getElementById('download_multiple').style.display = 'inline';
    document.getElementById('delete_multiple').style.display = 'inline';
  } else {
    document.getElementById('download_multiple').style.display = 'none';
    document.getElementById('delete_multiple').style.display = 'none';
  }
}

function display_options(arg) {
  $(arg).find('.options').css('color', '#7b7b7b');
}

function hide_options(arg) {
  $(arg).find('.options').css('color', '#fff');
}

function item_click(arg) {
  if (event.target.className == 'chkbox') {
    return false;
  }

  var obj = $(arg).find('.chkbox');
  obj.prop('checked', function (i, value) {
    return !value;
  });
  check_click();
}

function stop_bubble(e) {
  e.stopPropagation();
}
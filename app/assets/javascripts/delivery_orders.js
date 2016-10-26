function checkfile(sender) {
  var validExts = new Array(".csv");
  var fileExt = sender.value;
  fileExt = fileExt.substring(fileExt.lastIndexOf('.'));
  if (validExts.indexOf(fileExt) < 0) {
    toastr['error']("Solo se permiten archivos con extención " +
          validExts.toString() + "." + "\n Por favor seleccione un archivo valido.");
    $("#file").val("");
    return false;
  }
  else return true;
}

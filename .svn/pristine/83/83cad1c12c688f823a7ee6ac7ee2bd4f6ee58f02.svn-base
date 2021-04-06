function ObtenerUrlTareas(id) {

    var totalPath = location.href;
    aux = totalPath;
    var datos = new Array(5);
    var dato;

    var i = 0, casilla = 0;
    for (i = 0; i < aux.length; i++) {

        if (aux[i] != '/') {
            dato = dato + aux[i];
        } else {
            if (dato != "") {
                datos[casilla] = dato;
                dato = "";
                casilla++;
            }
        }
    }
  
    var Controller = datos[3];
    var UrlInicio = datos[1];
    var url = "http://" + UrlInicio + "/Intranet/Tareas/Insert?pTabla=" + Controller + "&pRegistroId=" + id;
    return window.location.href = url;
    /* var indexController = totalPath.toLocaleLowerCase().indexOf('/insert');
      if (indexController == -1) {
          indexController = totalPath.toLocaleLowerCase().indexOf('/registro');
      }
      var Controller = totalPath.slice(0, indexController);
      var finalPath = Controller + "/ObtenerDatos";
      return finalPath;*/

}

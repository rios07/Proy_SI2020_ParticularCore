//responsive datatables

$(document).ready(function () {
    fillDatatable();


});

function reloadDatatable() {
    $('#tableAjax').DataTable().destroy();
    fillDatatable();
    

    //QuitarHoraFechas();

}

function GetRadioValue(radioId) {
    return $('input[name=' + radioId + ']:checked').val();
}

function fillDatatable() {
    var headers = Array();

    $("#tableAjax tr th").each(function (i, v) {
        var header = { mask: "", field: "" };
        header.field = $(this).attr('field');
        header.mask = $(this).attr('mask');
        headers[i] = header;
    })

    var filtros = Array();

    $("[filtro]").each(function (i, v) {
        var filtro = { key: "", value: "" }
        filtro.key = $(this).attr('filtro');
        if ($(this).attr("type") === 'checkbox')
            filtro.value = $(this).is(":checked");
        else {
            if ($(this).attr("type") === "radio") {
                filtro.value = GetRadioValue('Radio-' + filtro.key);
            }
            else {
                if ($(this).attr('multiple') == 'multiple') {
                    if ($(this).val() != undefined) {
                        filtro.value = $(this).val().join();
                    }
                    else {
                        filtro.value = "";
                    }
                }
                else {
                    filtro.value = $(this).val();
                }
            }
        }
        filtros[i] = filtro;
    })

    var pagina = location.pathname.split("/")[3];

    $('#tableAjax').dataTable({
        "order": [[0, "desc"]],
        "oLanguage": {
            "sSearch": "",
            "sLengthMenu": "<span>_MENU_</span>",
            "sProcessing": "Procesando...",
            "sLengthMenu": "Mostrar _MENU_ registros",
            "sZeroRecords": "No se encontraron resultados",
            "sEmptyTable": "Ningún dato disponible en esta tabla",
            "sInfo": "Mostrando registros del _START_ al _END_ de un total de _TOTAL_ registros",
            "sInfoEmpty": "Mostrando registros del 0 al 0 de un total de 0 registros",
            "sInfoFiltered": "(filtrado de un total de _MAX_ registros)",
            "sInfoPostFix": "",
            "sSearch": "Buscar:",
            "sUrl": "",
            "sInfoThousands": ",",
            "sLoadingRecords": "Cargando...",
            "oPaginate": {
                "sFirst": "Primero",
                "sLast": "Último",
                "sNext": "Siguiente",
                "sPrevious": "Anterior"
            },
            "oAria": {
                "sSortAscending": ": Activar para ordenar la columna de manera ascendente",
                "sSortDescending": ": Activar para ordenar la columna de manera descendente"
            }
        },
        "lengthMenu": [[10, 25, 50,100,500,1000, -1], [10, 25, 50,100,500,1000, "Todos"]],
        "processing": true,
        "serverSide": true,
        "ajax": {
            "type": "POST",
            "contentType": "application/json; charset=utf-8",
            "url": GetURL(),
            "data": function (parameters) {
                parameters.headers = headers;
                parameters.filtros = filtros;
                parameters.activos = getActivos();
                return JSON.stringify({ parameters: parameters });
            },
            dataFilter: function (res) {
                // Web Method always returns the reponse in a d so it looks like
                // {d:string} where the string is the reponse from the web method.
                // Its a string because I serialize it before sending it out.
                // This bit of code takes that into account and converts it
                // to what DataTable is expecting.
                var parsed = JSON.parse(res);
                return JSON.stringify(parsed);
            }
            /*"dataSrc": function (json) {
            json.draw = json.d.draw;
            json.recordsTotal = json.d.recordsTotal;
            json.recordsFiltered = json.d.recordsFiltered;
            return json.d.data;
            }*/
        },
        //"columnDefs": [
        //    { "width": "1%", "targets": 0 }
        //],

        "sDom": "<'row'<'col-md-6 col-xs-12 'l><'col-md-6 col-xs-12'f>r>t<'row'<'col-md-4 col-xs-12'i><'col-md-8 col-xs-12'p>>"
    });
    
}

function GetURL() {
    var totalPath = location.href;
    var indexController = totalPath.toLocaleLowerCase().indexOf('/listado');
    if (indexController == -1) {
        indexController = totalPath.toLocaleLowerCase().indexOf('/update');
    }
    var Controller = totalPath.slice(0, indexController);
    var finalPath = Controller + "/ObtenerDatos";
    return finalPath
}
function getActivos() {
    if ($("#rblActivos_0").prop("checked"))    //Activos
        return true;
    if ($("#rblActivos_1").prop("checked"))    //Anulados
        return false;
    if ($("#rblActivos_2").prop("checked"))    //Todos
        return null;
    return true;                               // Por defecto, activos
}
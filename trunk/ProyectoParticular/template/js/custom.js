

//------------- PONEMOS ACÁ TODOS LOS NUESTROS -------------//

function mostrarImagen(src) {
        bootbox.alert({
            size: "large", 
            buttons: {},
            message: "<img src='" + src + "'></img>" });
    }

function AgregarABotonera(string) {
    $(".botonera").append(string)
}

$(document).ready(function () {
    //fijo el header y sidebar
    //$('body').data('dynamic').fixedHeader(true);
    //$('body').data('dynamic').fixedSidebar('left');

    ////oculto la barra de la derecha por ahora
    ////$('body').data('dynamic').hideRightSidebar();

    ////------------- Validación de campos -------------// 
    //    jQuery.extend(jQuery.validator.messages, {
    //        required: "Campo requerido.",
    //        remote: "Corrija el dato ingresado.",
    //        email: "Ingrese un e-mail válido.",
    //        url: "Ingrese una URL válida.",
    //        date: "Ingrese una fecha válida.",
    //        dateISO: "Ingrese una fecha válida (formato ISO).",
    //        number: "Ingrese un número.",
    //        digits: "Ingrese solo dígitos.",
    //        creditcard: "Ingrese un número de tarjeta de crédito válido.",
    //        equalTo: "Repita la misma contraseña ingresada.",
    //        accept: "Ingrese un valor con una extensión válida.",
    //        maxlength: jQuery.validator.format("No ingrese más de {0} caracteres."),
    //        minlength: jQuery.validator.format("Ingrese al menos {0} caracteres."),
    //        rangelength: jQuery.validator.format("La longitud de caracteres requerida es entre {0} y {1}."),
    //        range: jQuery.validator.format("El valor debe estar en el rango entre {0} y {1}."),
    //        max: jQuery.validator.format("Ingrese un valor igual o inferior a {0}."),
    //        //ddlmin: jQuery.validator.format("Selecciones un item."), (quería meter un texto distinto para los ddl, pero debe estar la fcion completa.
    //        min: jQuery.validator.format("Ingrese un valor igual o mayor a {0}.")
    //    });
    //if ($('[data-val-length-max]').length > 0) {
    //    $('[data-val-length-max]').each(function (input) {
    //        $('[data-val-length-max]').eq(input).attr('maxlength', ($('[data-val-length-max]').eq(input).attr('data-val-length-max')));
    //    })
    //    $('[data-val-length-max]').maxlength({
    //        alwaysShow: true,
    //        threshold: 10,
    //        warningClass: "label label-success",
    //        limitReachedClass: "label label-danger",
    //        separator: ' de ',
    //        preText: 'Utilizados ',
    //        postText: ' caracteres.',
    //        validate: true
    //    }); 
    //}



    //------------- Fancy select -------------// 
    if (typeof $().fancySelect === "function"){
        $('.fancy-select').fancySelect();
        //$('select').hide();
    }
    //-----------------------------------------// 


    //------------- Select 2 -------------//
    $('.select2').select2({ placeholder: '    -Todas-' });
    //-----------------------------------------// 


    //------------- Datepicker -------------//
    if (typeof $().datepicker === "function"){
        $(".basic-datepicker").datepicker({
            locale: 'es',
            format: 'dd/mm/yyyy'
        });
        $(".basic-datepicker").attr("readonly", "true");
    }
    //-----------------------------------------// 


    //------------- Timepicker -------------//
    if (typeof $().timepicker === "function"){
        $('.basic-timepicker').timepicker({
            upArrowStyle: 'fa fa-angle-up',
            downArrowStyle: 'fa fa-angle-down',
            dateFormat: "dd-mm-yyyy", 
        });
        $(".basic-timepicker").attr("readonly", "true");
        $('.tiempopicker').timepicker({
            // https://jdewit.github.io/bootstrap-timepicker/
            upArrowStyle: 'fa fa-angle-up',
            downArrowStyle: 'fa fa-angle-down',
            showSeconds: false,
            showMeridian: false,
            defaultTime: false
            // timeFormat: 'HH:mm',
            //format:'g:i',
            //formatTime: 'g:i',
            // mask:'29:59',
            // ampm: true,
            // setIs24HourView: true,
            // use24hours: true,
            // format: 'HH:mm a'
            // ampm: false
            // timeFormat: "HH:mm a"
            // timeFormat: "HH:mm"
            // timeFormat: "H:i"
        });
        $(".tiempopicker").attr("readonly", "true");
    }
    //-----------------------------------------// 


    //------------- Form validation -------------//
    if (typeof $().validate === "function"){
        var _rules = {};

        //agrego todos los controles requeridos a las reglas de validacion
        $("[requerido]").each(function (i, v) {
            if (!($(this).attr('name') in _rules)) _rules[$(this).attr('name')] = {} //si no existe el parámetro para ese control, lo creo
            _rules[$(this).attr('name')].required = true;
        })

        //agrego todos los controles con "minimo" a las reglas de validacion
        $("[minimo]").each(function (i, v) {
            if (!($(this).attr('name') in _rules)) _rules[$(this).attr('name')] = {} //si no existe el parámetro para ese control, lo creo
            _rules[$(this).attr('name')].min = $(this).attr('minimo'); 
        })

            //agrego todos los controles con "maximo" a las reglas de validacion
        $("[maximo]").each(function (i, v) {
            if (!($(this).attr('name') in _rules)) _rules[$(this).attr('name')] = {} //si no existe el parámetro para ese control, lo creo
            _rules[$(this).attr('name')].max = $(this).attr('maximo'); 
        })

        //agrego todos los controles con "email" a las reglas de validacion
        $("[email]").each(function (i, v) {
            if (!($(this).attr('name') in _rules)) _rules[$(this).attr('name')] = {} //si no existe el parámetro para ese control, lo creo
            _rules[$(this).attr('name')].email = true; 
        })

        //agrego todos los controles con "rangoMin" y "rangoMax" a las reglas de validacion
        $("[rangoMin]").each(function (i, v) {
            if (!($(this).attr('name') in _rules)) _rules[$(this).attr('name')] = {} //si no existe el parámetro para ese control, lo creo
            _rules[$(this).attr('name')].rangelength = [$(this).attr('rangoMin'), $(this).attr('rangoMax')]; 
        })

    
        $("#form1").validate({
            //debug: true,
            errorPlacement: function (error, element) {
                var place = element.closest('.input-group');
                if (!place.get(0)) {
                    place = element;
                }
                if (place.get(0).type === 'checkbox') {
                    place = element.parent();
                }
                if (error.text() !== '') {
                    place.after(error);
                }
            },
            errorClass: 'help-block',
            highlight: function (label) {
                $(label).closest('.form-group').removeClass('has-success').addClass('has-error');
            },
            success: function (label) {
                $(label).closest('.form-group').removeClass('has-error');
                label.remove();
            },
            rules: _rules
        });
    }
    //-----------------------------------------// 


    //------------- Masked input fields -------------//
    if (typeof $().mask === "function"){
        $("[mask-phone]").mask("(999) 999-9999", { completed: function () { alert("Callback action after complete"); } });
        $("[mask-phoneExt]").mask("(999) 999-9999? x99999");
        $("[mask-phoneInt]").mask("+40 999 999 999");
        $("[mask-fecha]").mask("99/99/9999");
        $('[mask-hora]').mask("99:99");
        $("[mask-ssn]").mask("999-99-9999");
        $("[mask-productKey]").mask("a*-999-a999", { placeholder: "*" });
        $("[mask-eyeScript]").mask("~9.99 ~9.99 999");
        $("[mask-percent]").mask("99%");
    }
    //-----------------------------------------// 

    
});
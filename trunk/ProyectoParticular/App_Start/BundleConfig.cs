using System.Web;
using System.Web.Optimization;

namespace ProyectoParticular
{
    public class BundleConfig
    {
        // For more information on bundling, visit https://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                         //"~/Template/js/libs/jquery-2.1.1.min.js",
                         //"~/Template/js/libs/jquery-ui-1.10.4.js",
                         "~/template/js/jquery.min.js",
                         "~/Template/plugins/core/quicksearch/*.js",
                         "~/Template/plugins/core/slimscroll/jquery.slimscroll.min.js",
                         "~/Template/plugins/core/slimscroll/jquery.slimscroll.horizontal.min.js",
                         "~/Template/js/jquery.dynamic.js"

                         ));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/jquery.validate*"));

            // Utilice la versión de desarrollo de Modernizr para desarrollar y obtener información. De este modo, estará
            // ready for production, use the build tool at https://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                      "~/Template/js/bootstrap.min.js",
                      "~/Template/js/customScripts.js",
                      "~/Scripts/respond.js"));

            bundles.Add(new StyleBundle("~/bundles/css").Include(
                    "~/template/css/bootstrap.min.css",
                    "~/template/css/icons.css",
                    "~/template/css/style.css",
                    "~/template/css/main.css",
                    "~/template/plugins/bootstrap-datepicker/css/bootstrap-datepicker.min.css",
                    "~/template/plugins/sweet-alert2/sweetalert2.css",
                    "~/template/css/custom.css",
                    "~/template/plugins/bootstrap-datepicker/css/bootstrap-datepicker.min.css",
                    "~/Content/css/select2.css",
                    "~/template/plugins/alertify/css/alertify.css",
                    "~/template/plugins/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.css"));

            bundles.Add(new ScriptBundle("~/bundles/templatejs").Include(

                      "~/template/js/tether.min.js",

                      "~/template/js/modernizr.min.js",
                      "~/template/js/detect.js",
                      "~/template/js/fastclick.js",
                      "~/template/js/jquery.slimscroll.js",
                      "~/template/js/jquery.blockUI.js",
                      "~/template/js/waves.js",
                      "~/template/js/jquery.nicescroll.js",
                      "~/template/js/jquery.scrollTo.min.js",
                      "~/Scripts/jquery.validate.js",
                      "~/Scripts/jquery.validate.unobtrusive.js",
                      "~/Scripts/select2.js",
                      "~/template/plugins/tinymce/tinymce.min.js",
                      "~/template/plugins/bootstrap-datepicker/js/bootstrap-datepicker.min.js",
                      "~/template/plugins/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js",
                      "~/template/plugins/bootstrap-datetimepicker-master/js/locales/bootstrap-datetimepicker.es.js",
                      "~/template/plugins/sweet-alert2/sweetalert2.js",
                      "~/template/plugins/notify/jquery.gritter.js",
                      "~/template/plugins/alertify/js/alertify.js",
                      "~/template/plugins/bootstrap-maxlength/src/bootstrap-maxlength.js"
                      ));

            bundles.Add(new StyleBundle("~/bundles/templatecss").Include(
                    "~/Template/css/*.css"));

            BundleTable.EnableOptimizations = true;
        }
    }
}

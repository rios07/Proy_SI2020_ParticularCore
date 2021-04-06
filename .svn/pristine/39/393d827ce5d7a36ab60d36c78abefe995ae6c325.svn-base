using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Routing;

namespace ProyectoParticular
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapHttpRoute(
                name: "API Default",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );

            routes.MapRoute(
                name: "seccion",
                url: "{pSeccion}/{controller}/{action}/{pParam}",
                defaults: new { pSeccion = "Intranet", controller = "Home", action = "Index", pParam = UrlParameter.Optional }
            );

            routes.MapRoute(
                name: "seccionOnly",
                url: "{pSeccion}",
                defaults: new { pSeccion = "Intranet", controller = "Home", action = "Index" }
            );

            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{pParam}",
                defaults: new { pSeccion = "intranet", controller = "Home", action = "Index", pParam = UrlParameter.Optional }
            );

            
        }
    }
}

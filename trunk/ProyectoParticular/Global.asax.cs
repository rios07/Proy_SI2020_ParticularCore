using _DatosDelSistema;
using Autofac;
using Autofac.Integration.Mvc;
using AutoMapper;
using ControladoresCore.Base;
using ControladoresCore.ViewModels;
using RepositoriosCore;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
//using ModelosP;
//using ProyectoParticular.ViewModels;
using System.Threading;
using System.Diagnostics;
using System.Web.Http;
using Autofac.Integration.WebApi;
//using ControladoresP.ViewModels;
//using ModelosP;
using ServiciosCore;
//using ControladoresP.ViewModels;


namespace ProyectoParticular
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);


            GlobalConfiguration.Configuration.MessageHandlers.Add(new TokenValidationHandler());
            var formatters = GlobalConfiguration.Configuration.Formatters;
            formatters.Remove(formatters.XmlFormatter);

            Assembly repositorios = null;
            try
            {
                repositorios = Assembly.Load("RepositoriosP");
            }
            catch (Exception ex)
            {
                Console.WriteLine("no pude cargar RepositoriosP: " + ex.Message);
            }

            Assembly servicios = null;
            try
            {
                servicios = Assembly.Load("ServiciosP");
            }
            catch (Exception ex)
            {
                Console.WriteLine("no pude cargar ServiciosP: " + ex.Message);
            }

            //creo el contenedor
            var builder = new ContainerBuilder();

            //registro todos los controllers (magia)
            builder.RegisterControllers(Assembly.GetExecutingAssembly());

            //registro todos los controllers de la API (magia)
            builder.RegisterApiControllers("Controller",Assembly.GetExecutingAssembly());


            //busco todas las clases que terminen con "Repositorio" (convencion) y las "publico" como sus interfaces
            if (repositorios != null)
            {
                builder.RegisterAssemblyTypes(repositorios)
                .Where(t => t.Name.EndsWith("Repositorio"))
                .AsImplementedInterfaces().InstancePerRequest();
            }


            //busco todas las clases que terminen con "Servicio" (convencion) y las "publico" como sus interfaces
            if (servicios != null)
            {
                builder.RegisterAssemblyTypes(servicios)
                .Where(t => t.Name.EndsWith("Servicio"))
                .AsImplementedInterfaces().InstancePerRequest();
            }

            //inicializaciones del Core
            BaseGlobal.InitAutofac<miConexion>(builder);
            BaseGlobal.InitAutomapper<PMappings>();
            //InitAutomapper();
            ModelMetadataProviders.Current = new BaseGlobal.CustomModelMetadataProvider();

            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            //Envios de Mail Pendientes

            //var CorreoServicio = new EnviosDeCorreosServicio(new EnviosDeCorreosRepositorio(new miConexion()),new LogEnviosDeCorreosRepositorio(new miConexion()));
            //var waitHandle = new AutoResetEvent(false);
            //ThreadPool.RegisterWaitForSingleObject(
            //    waitHandle,
            //    // Method to execute
            //    (state, timeout) =>
            //    {
            //        CorreoServicio.EnviarPendientes();
                    
            //        //FuncionesCore.FMails.Enviar("test_web@something.com", "T3si1taw3B", "jtomas@something.com", "YUUP YUUP", "Esto funciono veces", "eseemetepe.1and1.com", "Global.asax", "Async timer");
            //    },
            //    // optional state object to pass to the method
            //    null,
            //    // Execute the method after x seconds
            //    TimeSpan.FromSeconds(60),
            //    // Set this to false to execute it repeatedly every 5 seconds
            //    false
            //);
        }

       

        public class miConexion : IConexion
        {
            public SqlConnection GetConexion()
            {
                if (ControlDelSitio.SitioActivo)
                {
                    string PC = "";
                    string DataSource = ""; 
                    string Database = "DB_ParticularCore";
                    string User_ID = "User_Login_DB_ParticularCore";
                    string Password = "4nH2dV61FsT4J2eE"; //4nH2dV61FsT4J2eE

                    PC = Environment.MachineName.ToUpper();

                    switch (PC)
                    {
                        
                        case "IS53":
                            PC = "PC204";
                            DataSource = PC + "\\SQLEXPRESS";
                            break;
                        
                        case "PC225":

                            PC = "172.31.100.40";
                            DataSource = PC + "\\i2K8R2_DES";
                            //PC = "PC204";
                            //DataSource = PC + "\\SQLEXPRESS";
                            break;
                        case "PC204":

                            PC = "172.31.100.40";
                            DataSource = PC + "\\i2K8R2_DES";
                            //PC = "PC204";
                            //DataSource = PC + "\\SQLEXPRESS";
                            break;
                        case "IS40":
                            PC = "172.31.100.40";
                            DataSource = PC + "\\i2K8R2_DES";
                            break;
                        case "IS43":
                            PC = "172.31.100.40";
                            DataSource = PC + "\\i2K8R2_DES";
                            break;
                        default:
                            PC = "inválida";
                            break;
                    }

                   

                    return new SqlConnection("Data Source=" + DataSource + "; Database=" + Database + ";User ID=" + User_ID + ";Password=" + Password);
                }
                else
                {
                    return null; // No se puede utilizar el sitio, está seteado como NO ACTIVO.
                }
            }
        }

        //agregar mapeos acá
        public class PMappings : Profile
        {
            public PMappings()
            {
                

            }
        }

        


    }
}

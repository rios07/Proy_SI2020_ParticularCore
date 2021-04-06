using ControladoresCore.Base;
using ControladoresCore.ViewModels;
using ModelosCore;
using ServiciosCore;


namespace ProyectoParticular.ApiControllers
{
    public class InformesController : BaseApiController<Informes, InformesExt, InformesVM>
    {
        private IInformesServicio _InformesServicio;

        public InformesController(IInformesServicio pInformesSevicio)
        {
            _InformesServicio = pInformesSevicio;
        }

        protected override IBaseServicios<Informes, InformesExt> GetServicio()
        {
            return _InformesServicio;
        }

    }
}

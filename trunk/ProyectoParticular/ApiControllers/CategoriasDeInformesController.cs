using ControladoresCore.Base;
using ControladoresCore.ViewModels;
using ModelosCore;
using ServiciosCore;


namespace ProyectoParticular.ApiControllers
{
    public class CategoriasDeInformesController : BaseApiController<CategoriasDeInformes, CategoriasDeInformesExt, CategoriasDeInformesVM>
    {
        private ICategoriasDeInformesServicio _CategoriasDeInformesServicio;

        public CategoriasDeInformesController(ICategoriasDeInformesServicio pCategoriasDeInformesSevicio)
        {
            _CategoriasDeInformesServicio = pCategoriasDeInformesSevicio;
        }

        protected override IBaseServicios<CategoriasDeInformes, CategoriasDeInformesExt> GetServicio()
        {
            return _CategoriasDeInformesServicio;
        }

    }
}

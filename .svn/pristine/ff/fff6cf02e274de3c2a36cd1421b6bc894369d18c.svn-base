using ControladoresCore.Base;
using ControladoresCore.ViewModels;
using ModelosCore;
using ServiciosCore;


namespace ProyectoParticular.ApiControllers
{
    public class UsuariosController : BaseApiController<Usuarios, UsuariosExt, UsuariosVM>
    {
        private IUsuariosServicio _UsuariosServicio;

        public UsuariosController(IUsuariosServicio pUsuariosSevicio)
        {
            _UsuariosServicio = pUsuariosSevicio;
        }

        protected override IBaseServicios<Usuarios, UsuariosExt> GetServicio()
        {
            return _UsuariosServicio;
        }

    }
}

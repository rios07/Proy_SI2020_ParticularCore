using ControladoresCore.Base;
using ControladoresCore.ViewModels;
using ModelosCore;
using ServiciosCore;


namespace ProyectoParticular.ApiControllers
{

    public class RolesDeUsuariosController : BaseApiController<RolesDeUsuarios, RolesDeUsuariosExt, RolesDeUsuariosVM>
    {
        private IRolesDeUsuariosServicio _rolesDeUsuariosServicio;

        public RolesDeUsuariosController(IRolesDeUsuariosServicio pRolesDeUsuariosServicio)
        {
            _rolesDeUsuariosServicio = pRolesDeUsuariosServicio;
        }

        protected override IBaseServicios<RolesDeUsuarios, RolesDeUsuariosExt> GetServicio()
        {
            return _rolesDeUsuariosServicio;
        }

    }
}

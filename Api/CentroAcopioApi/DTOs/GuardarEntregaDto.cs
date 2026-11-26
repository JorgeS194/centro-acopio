using System.ComponentModel.DataAnnotations;
using CentroAcopioApi.Constantes;

namespace CentroAcopioApi.DTOs
{
    /// <summary>
    /// Datos de entrada para crear o editar una entrega.
    /// </summary>
    public class GuardarEntregaDto
    {
        [Range(1, int.MaxValue, ErrorMessage = "Seleccione un beneficiario.")]
        public int BeneficiarioId { get; set; }

        [Range(1, int.MaxValue, ErrorMessage = "Seleccione un producto.")]
        public int ProductoId { get; set; }

        [Range(1, Catalogo.MAXIMO_CANTIDAD, ErrorMessage = "La cantidad debe estar entre 1 y 10 000.")]
        public int Cantidad { get; set; }

        public string? Talla { get; set; }
        public string? GrupoEdad { get; set; }
        public string? Sexo { get; set; }
    }
}
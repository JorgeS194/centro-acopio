using System.ComponentModel.DataAnnotations;
using CentroAcopioApi.Constantes;

namespace CentroAcopioApi.DTOs
{
    /// <summary>
    /// Datos de entrada para crear o editar una donación.
    /// </summary>
    public class GuardarDonacionDto
    {
        [Range(1, int.MaxValue, ErrorMessage = "Seleccione un producto.")]
        public int ProductoId { get; set; }

        public int? DonanteId { get; set; }

        [Required(ErrorMessage = "La descripción es obligatoria.")]
        [StringLength(250, MinimumLength = 3, ErrorMessage = "La descripción debe tener entre 3 y 250 caracteres.")]
        public string Descripcion { get; set; } = string.Empty;

        [Range(1, Catalogo.MAXIMO_CANTIDAD, ErrorMessage = "La cantidad debe estar entre 1 y 10 000.")]
        public int Cantidad { get; set; }

        public string? Talla { get; set; }
        public string? GrupoEdad { get; set; }
        public string? Sexo { get; set; }
    }
}   
using System.ComponentModel.DataAnnotations;
using CentroAcopioApi.Constantes;

namespace CentroAcopioApi.DTOs
{
    /// <summary>
    /// Datos de entrada para crear o editar un producto.
    /// </summary>
    public class GuardarProductoDto
    {
        [Required(ErrorMessage = "El nombre del producto es obligatorio.")]
        [StringLength(100, MinimumLength = 2, ErrorMessage = "El nombre debe tener entre 2 y 100 caracteres.")]
        [RegularExpression(Catalogo.REGEX_NOMBRE_PRODUCTO, ErrorMessage = "El nombre solo puede contener letras, números, espacios y guiones.")]
        public string Nombre { get; set; } = string.Empty;

        [Required(ErrorMessage = "El tipo de producto es obligatorio.")]
        [StringLength(20, ErrorMessage = "El tipo no puede exceder los 20 caracteres.")]
        public string Tipo { get; set; } = string.Empty;
    }
}
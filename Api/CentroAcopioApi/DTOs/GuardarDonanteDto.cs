using System.ComponentModel.DataAnnotations;
using CentroAcopioApi.Constantes;

namespace CentroAcopioApi.DTOs
{
    /// <summary>
    /// Datos de entrada para crear o editar un donante.
    /// </summary>
    public class GuardarDonanteDto
    {
        [Required(ErrorMessage = "La cédula es obligatoria.")]
        [StringLength(20, ErrorMessage = "La cédula no puede exceder los 20 caracteres.")]
        [RegularExpression(Catalogo.REGEX_CEDULA, ErrorMessage = "El formato de la cédula no es válido.")]
        public string Cedula { get; set; } = string.Empty;

        [Required(ErrorMessage = "El nombre es obligatorio.")]
        [StringLength(100, MinimumLength = 2, ErrorMessage = "El nombre debe tener entre 2 y 100 caracteres.")]
        [RegularExpression(Catalogo.REGEX_NOMBRE_PERSONA, ErrorMessage = "El nombre solo puede contener letras, espacios, guiones y apóstrofes.")]
        public string Nombre { get; set; } = string.Empty;

        [Required(ErrorMessage = "El teléfono es obligatorio.")]
        [RegularExpression(Catalogo.REGEX_TELEFONO, ErrorMessage = "El teléfono debe tener 7 u 8 dígitos.")]
        public string Telefono { get; set; } = string.Empty;
    }
}
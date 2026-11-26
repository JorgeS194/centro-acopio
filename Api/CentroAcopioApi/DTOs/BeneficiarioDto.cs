namespace CentroAcopioApi.DTOs
{
    /// <summary>
    /// Datos de salida de un beneficiario.
    /// </summary>
    public record BeneficiarioDto(int Id, string Cedula, string Nombre, string Telefono, string? Direccion);
}
namespace CentroAcopioApi.DTOs
{
    /// <summary>
    /// Datos de salida de una entrega.
    /// </summary>
    public record EntregaDto(
        int Id,
        DateTime Fecha,
        int BeneficiarioId,
        string BeneficiarioNombre,
        int ProductoId,
        string ProductoNombre,
        string Tipo,
        int Cantidad,
        string? Talla,
        string? GrupoEdad,
        string? Sexo);
}
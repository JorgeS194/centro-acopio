namespace CentroAcopioApi.DTOs
{
    /// <summary>
    /// Datos de salida de una donación.
    /// </summary>
    public record DonacionDto(
        int Id,
        DateTime Fecha,
        int ProductoId,
        string ProductoNombre,
        string Tipo,
        int? DonanteId,
        string? DonanteNombre,
        string Descripcion,
        int Cantidad,
        string? Talla,
        string? GrupoEdad,
        string? Sexo);
}
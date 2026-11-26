namespace CentroAcopioApi.DTOs
{
    /// <summary>
    /// Datos de salida de totales agrupados por tipo de producto.
    /// </summary>
    public record TotalPorTipoDto(
        string Tipo,
        int TotalDonado,
        int TotalEntregado,
        int Disponible);
}
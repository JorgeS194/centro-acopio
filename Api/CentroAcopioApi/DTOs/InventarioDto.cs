namespace CentroAcopioApi.DTOs
{
    /// <summary>
    /// Datos de salida del estado de inventario por artículo.
    /// </summary>
    public record InventarioDto(
        int ProductoId,
        string ProductoNombre,
        string Tipo,
        string? Talla,
        string? GrupoEdad,
        string? Sexo,
        int TotalDonado,
        int TotalEntregado,
        int Disponible);
}
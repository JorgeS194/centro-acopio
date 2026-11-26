namespace CentroAcopioApi.DTOs
{
    /// <summary>
    /// Datos de salida del historial combinado de donaciones y entregas.
    /// </summary>
    public record MovimientoDto(
        DateTime Fecha,
        string Movimiento,
        string ProductoNombre,
        string Tipo,
        int Cantidad,
        string? Talla,
        string? GrupoEdad,
        string? Sexo,
        string Persona);
}
namespace CentroAcopioApi.DTOs
{
    /// <summary>
    /// Datos de salida de un donante.
    /// </summary>
    public record DonanteDto(int Id, string Cedula, string Nombre, string Telefono);
}
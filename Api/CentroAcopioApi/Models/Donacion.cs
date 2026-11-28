using System;
using System.Collections.Generic;

namespace CentroAcopioApi.Models;

public partial class Donacion
{
    public int Id { get; set; }

    public DateTime Fecha { get; set; }

    public int ProductoId { get; set; }

    public int? DonanteId { get; set; }

    public string Descripcion { get; set; } = null!;

    public int Cantidad { get; set; }

    public string? Talla { get; set; }

    public string? GrupoEdad { get; set; }

    public string? Sexo { get; set; }

    public virtual Donante? Donante { get; set; }

    public virtual Producto Producto { get; set; } = null!;
}

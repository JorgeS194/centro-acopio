using System;
using System.Collections.Generic;

namespace CentroAcopioApi.Models;

public partial class Beneficiario
{
    public int Id { get; set; }

    public string Cedula { get; set; } = null!;

    public string Nombre { get; set; } = null!;

    public string Telefono { get; set; } = null!;

    public string? Direccion { get; set; }

    public virtual ICollection<Entrega> Entregas { get; set; } = new List<Entrega>();
}

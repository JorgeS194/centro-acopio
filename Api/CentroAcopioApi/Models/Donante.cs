using System;
using System.Collections.Generic;

namespace CentroAcopioApi.Models;

public partial class Donante
{
    public int Id { get; set; }

    public string Cedula { get; set; } = null!;

    public string Nombre { get; set; } = null!;

    public string Telefono { get; set; } = null!;

    public virtual ICollection<Donacion> Donaciones { get; set; } = new List<Donacion>();
}

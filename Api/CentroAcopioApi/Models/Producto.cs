using System;
using System.Collections.Generic;

namespace CentroAcopioApi.Models;

public partial class Producto
{
    public int Id { get; set; }

    public string Nombre { get; set; } = null!;

    public string Tipo { get; set; } = null!;

    public virtual ICollection<Donacion> Donaciones { get; set; } = new List<Donacion>();

    public virtual ICollection<Entrega> Entregas { get; set; } = new List<Entrega>();
}

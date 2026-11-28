using System;
using System.Collections.Generic;

namespace CentroAcopioApi.Models;

public partial class Entrega
{
    public int Id { get; set; }

    public DateTime Fecha { get; set; }

    public int BeneficiarioId { get; set; }

    public int ProductoId { get; set; }

    public int Cantidad { get; set; }

    public string? Talla { get; set; }

    public string? GrupoEdad { get; set; }

    public string? Sexo { get; set; }

    public virtual Beneficiario Beneficiario { get; set; } = null!;

    public virtual Producto Producto { get; set; } = null!;
}

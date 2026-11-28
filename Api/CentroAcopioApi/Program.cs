using CentroAcopioApi.Exceptions;
using CentroAcopioApi.Data;
using CentroAcopioApi.Exceptions;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// REGISTRO DE SERVICIOS

builder.Services.AddControllers(opciones => opciones.Filters.Add<FiltroExcepciones>());
builder.Services.AddOpenApi();

// Respuestas de error con formato estándar (ProblemDetails).
builder.Services.AddProblemDetails();

// El DbContext generado, con la cadena de conexión de appsettings.Development.json.
builder.Services.AddDbContext<CentroAcopioDbContext>(opciones =>
    opciones.UseSqlServer(builder.Configuration.GetConnectionString("CentroAcopioDb")));

// --- Servicios de Jorge: Productos, Donaciones, Stock ---
// --- Servicios de Moisés: Donantes, Beneficiarios, Entregas ---
// --- Servicios de Moisés: Inventario, Reportes ---

var app = builder.Build();

// PIPELINE HTTP

// Captura cualquier excepción no controlada y responde 500 sin exponer detalles internos.
app.UseExceptionHandler();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.UseSwaggerUI(options =>
        options.SwaggerEndpoint("/openapi/v1.json", "API Centro de Acopio v1"));
}

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();

app.Run();
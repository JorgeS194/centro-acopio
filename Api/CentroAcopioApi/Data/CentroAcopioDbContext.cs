using System;
using System.Collections.Generic;
using CentroAcopioApi.Models;
using Microsoft.EntityFrameworkCore;

namespace CentroAcopioApi.Data;

public partial class CentroAcopioDbContext : DbContext
{
    public CentroAcopioDbContext(DbContextOptions<CentroAcopioDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Beneficiario> Beneficiarios { get; set; }

    public virtual DbSet<Donacion> Donaciones { get; set; }

    public virtual DbSet<Donante> Donantes { get; set; }

    public virtual DbSet<Entrega> Entregas { get; set; }

    public virtual DbSet<Producto> Productos { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Beneficiario>(entity =>
        {
            entity.HasIndex(e => e.Cedula, "UQ_Beneficiarios_Cedula").IsUnique();

            entity.Property(e => e.Cedula).HasMaxLength(20);
            entity.Property(e => e.Direccion).HasMaxLength(200);
            entity.Property(e => e.Nombre).HasMaxLength(100);
            entity.Property(e => e.Telefono).HasMaxLength(8);
        });

        modelBuilder.Entity<Donacion>(entity =>
        {
            entity.Property(e => e.Descripcion).HasMaxLength(250);
            entity.Property(e => e.Fecha)
                .HasPrecision(0)
                .HasDefaultValueSql("(sysdatetime())", "DF_Donaciones_Fecha");
            entity.Property(e => e.GrupoEdad).HasMaxLength(10);
            entity.Property(e => e.Sexo).HasMaxLength(10);
            entity.Property(e => e.Talla).HasMaxLength(5);

            entity.HasOne(d => d.Donante).WithMany(p => p.Donaciones)
                .HasForeignKey(d => d.DonanteId)
                .HasConstraintName("FK_Donaciones_Donantes");

            entity.HasOne(d => d.Producto).WithMany(p => p.Donaciones)
                .HasForeignKey(d => d.ProductoId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Donaciones_Productos");
        });

        modelBuilder.Entity<Donante>(entity =>
        {
            entity.HasIndex(e => e.Cedula, "UQ_Donantes_Cedula").IsUnique();

            entity.Property(e => e.Cedula).HasMaxLength(20);
            entity.Property(e => e.Nombre).HasMaxLength(100);
            entity.Property(e => e.Telefono).HasMaxLength(8);
        });

        modelBuilder.Entity<Entrega>(entity =>
        {
            entity.Property(e => e.Fecha)
                .HasPrecision(0)
                .HasDefaultValueSql("(sysdatetime())", "DF_Entregas_Fecha");
            entity.Property(e => e.GrupoEdad).HasMaxLength(10);
            entity.Property(e => e.Sexo).HasMaxLength(10);
            entity.Property(e => e.Talla).HasMaxLength(5);

            entity.HasOne(d => d.Beneficiario).WithMany(p => p.Entregas)
                .HasForeignKey(d => d.BeneficiarioId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Entregas_Beneficiarios");

            entity.HasOne(d => d.Producto).WithMany(p => p.Entregas)
                .HasForeignKey(d => d.ProductoId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Entregas_Productos");
        });

        modelBuilder.Entity<Producto>(entity =>
        {
            entity.HasIndex(e => e.Nombre, "UQ_Productos_Nombre").IsUnique();

            entity.Property(e => e.Nombre).HasMaxLength(100);
            entity.Property(e => e.Tipo).HasMaxLength(20);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}

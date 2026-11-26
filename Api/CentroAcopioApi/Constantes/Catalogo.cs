namespace CentroAcopioApi.Constantes
{
    /// <summary>
    /// Constantes compartidas y expresiones regulares de validación para toda la API.
    /// </summary>
    public static class Catalogo
    {
        public const string ALIMENTOS = "Alimentos";
        public const string INSUMOS = "Insumos";
        public const string ROPA = "Ropa";

        public static readonly string[] TIPOS = [ALIMENTOS, INSUMOS, ROPA];
        public static readonly string[] TALLAS = ["XS", "S", "M", "L", "XL", "XXL"];
        public static readonly string[] GRUPOS_EDAD = ["Niño", "Adulto"];
        public static readonly string[] SEXOS = ["Hombre", "Mujer", "Unisex"];

        public const int MAXIMO_CANTIDAD = 10000;

        public const string REGEX_CEDULA = @"^(?:PE|E|N|1[0-3]|[1-9])-\d{1,4}-\d{1,6}$";
        public const string REGEX_TELEFONO = @"^\d{7,8}$";
        public const string REGEX_NOMBRE_PERSONA = @"^[\p{L}][\p{L}' \-]+$";
        public const string REGEX_NOMBRE_PRODUCTO = @"^[\p{L}\p{N}][\p{L}\p{N} \-]+$";
    }
}
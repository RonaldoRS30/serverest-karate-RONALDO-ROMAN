# Pruebas de API ServeRest con Karate

Pruebas del CRUD de usuarios de [ServeRest](https://serverest.dev), hechas con Karate.

Autor: Ronaldo Roman  
Repositorio: [serverest-karate-RONALDO-ROMAN](https://github.com/RonaldoRS30/serverest-karate-RONALDO-ROMAN)

## Cómo ejecutarlo

Hace falta Java 17, Maven e internet.

Desde la carpeta del proyecto:

```bash
mvn test
```

El reporte se abre en `karate-reports/karate-summary.html`. El detalle de la última ejecución está en [INFORME.md](INFORME.md).

En cada push a `main`, GitHub Actions vuelve a correr `mvn test`.

# Pruebas de API ServeRest con Karate

Pruebas del CRUD de usuarios de [ServeRest](https://serverest.dev), hechas con Karate.

Autor: Ronaldo Roman  
Repositorio: [serverest-karate-RONALDO-ROMAN](https://github.com/RonaldoRS30/serverest-karate-RONALDO-ROMAN)

## Cómo ejecutarlo

Hace falta Java 17, Maven e internet. Los comandos se corren desde la carpeta del proyecto.

Todo:

```bash
mvn test
```

Solo los casos que salen bien:

```bash
mvn test "-Dkarate.options=--tags @positivo"
```

Solo los casos que la API debe rechazar:

```bash
mvn test "-Dkarate.options=--tags @negativo"
```

Un solo feature, por ejemplo el alta:

```bash
mvn test "-Dkarate.options=classpath:resources/features/post-usuarios.feature"
```

El reporte se abre en `karate-reports/karate-summary.html`. El detalle de la última ejecución está en [INFORME.md](INFORME.md).

En cada push a `main`, GitHub Actions vuelve a correr la suite completa.

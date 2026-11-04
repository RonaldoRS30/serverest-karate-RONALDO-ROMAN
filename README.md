# Pruebas de API ServeRest con Karate

Autor: Ronaldo Roman  
Repositorio: [serverest-karate-RONALDO-ROMAN](https://github.com/RonaldoRS30/serverest-karate-RONALDO-ROMAN)

Hace falta Java 17, Maven e internet. Los comandos se corren desde la carpeta del proyecto.

## API utilizada

[ServeRest](https://serverest.dev): alta, consulta, actualización y eliminación de usuarios. Incluye casos que salen bien y casos en los que la API debe responder error.

## Ejecutar todo

```bash
mvn clean test
```

## Ejecutar pruebas positivas

```bash
mvn clean test "-Dkarate.options=--tags @positivo"
```

## Ejecutar pruebas negativas

```bash
mvn clean test "-Dkarate.options=--tags @negativo"
```

## Validación CI

En cada push y en cada pull request a `main`, GitHub Actions corre la suite completa.

El reporte queda en `karate-reports/karate-summary.html`. El detalle de la última corrida está en [INFORME.md](INFORME.md).

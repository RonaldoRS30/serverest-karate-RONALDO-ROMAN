# Pruebas de API ServeRest con Karate

Pruebas automatizadas del CRUD de usuarios de [ServeRest](https://serverest.dev), escritas con Karate DSL y ejecutadas con JUnit 5 y Maven.

Autor: Ronaldo Roman  
Repositorio: [serverest-karate-RONALDO-ROMAN](https://github.com/RonaldoRS30/serverest-karate-RONALDO-ROMAN)  
Informe de la ejecución: [INFORME.md](INFORME.md)

## Qué se prueba

La API base es `https://serverest.dev`. El alcance es el recurso `/usuarios`:

| Método | Ruta | Feature |
| --- | --- | --- |
| POST | `/usuarios` | `post-usuarios.feature` |
| GET | `/usuarios` | `get-usuarios.feature` |
| GET | `/usuarios/{_id}` | `get-usuario-por-id.feature` |
| PUT | `/usuarios/{_id}` | `put-usuarios.feature` |
| DELETE | `/usuarios/{_id}` | `delete-usuarios.feature` |

Cada feature tiene casos positivos y negativos. Los datos de alta se generan con email único para poder repetir la suite sobre la API pública.

## Requisitos

- Java 17
- Maven 3
- Conexión a internet (las pruebas llaman a `https://serverest.dev`)

## Cómo ejecutar

Desde la raíz del proyecto:

```bash
mvn test
```

El runner `UsuariosTest` ejecuta solo los features de `src/test/java/usuarios`. El feature `helpers/crear-usuario.feature` no corre solo: lo llaman los escenarios que necesitan un usuario ya creado.

Al terminar, el reporte HTML queda en:

```text
target/karate-reports/karate-summary.html
```

La última ejecución de esta suite dejó 22 escenarios en verde. El detalle está en [INFORME.md](INFORME.md).

## Estructura

```text
src/test/java/
├── karate-config.js                 URL base y timeouts
├── logback-test.xml
├── runners/UsuariosTest.java        Punto de entrada de JUnit 5
├── helpers/
│   ├── DataGenerator.java           Nombre, email y password únicos
│   └── crear-usuario.feature        Alta reutilizable (call)
├── schemas/usuario-schema.json      Contrato de un usuario
└── usuarios/                        Un feature por endpoint
```

`karate-config.js` publica `baseUrl` para todos los features. `DataGenerator` arma emails con UUID, por ejemplo `qa_a3f9c2d1@test.com`.

## Tecnologías

- Karate DSL 1.4.1
- JUnit 5, mediante `karate-junit5`
- Maven Surefire 3.2.5

# Informe de pruebas — API de usuarios ServeRest

Autor: Ronaldo Roman  
Repositorio: [serverest-karate-RONALDO-ROMAN](https://github.com/RonaldoRS30/serverest-karate-RONALDO-ROMAN)  
API: [https://serverest.dev](https://serverest.dev)  
Fecha de la ejecución: 3 de noviembre de 2026  
Herramienta: Karate DSL 1.4.1, JUnit 5 y Maven

## 1. Objetivo

Comprobar el CRUD del recurso `/usuarios` de ServeRest: el alta, el listado, la búsqueda por id, la actualización y la eliminación. La suite cubre respuestas correctas, datos inválidos y el comportamiento real de la API cuando el id no existe.

## 2. Alcance

Se probaron estos cinco endpoints:

| Operación | Método y ruta |
| --- | --- |
| Registrar usuario | `POST /usuarios` |
| Listar y filtrar | `GET /usuarios` |
| Buscar por id | `GET /usuarios/{_id}` |
| Actualizar | `PUT /usuarios/{_id}` |
| Eliminar | `DELETE /usuarios/{_id}` |

Quedaron fuera de alcance el login, los productos y los carritos. La URL y los timeouts (10 segundos) están en `src/test/java/karate-config.js`.

## 3. Organización del proyecto

Hay un feature por endpoint, dentro de `src/test/java/usuarios`. El runner `UsuariosTest` ejecuta `classpath:usuarios`, así que el helper no aparece como una prueba independiente.

| Pieza | Función |
| --- | --- |
| `helpers/DataGenerator.java` | Genera nombre, email y contraseña con un UUID corto |
| `helpers/crear-usuario.feature` | Hace el POST válido y devuelve `idUsuario` y `cuerpoUsuario` |
| `schemas/usuario-schema.json` | Describe `_id`, `nome`, `email`, `password` y `administrador` |

Los escenarios que necesitan un usuario previo lo crean con:

```gherkin
* def creado = call crearUsuario
* def idUsuario = creado.idUsuario
* def cuerpo = creado.cuerpoUsuario
```

El alta válida de `POST /usuarios` sigue escrita en su propio escenario, porque ese caso es el que demuestra el endpoint.

## 4. Datos de prueba

Cada usuario creado usa un email distinto (`qa_<uuid>@test.com`), así la suite se puede repetir en la API pública sin chocar con registros anteriores.

En las tablas de datos inválidos los emails son fijos (`a1@test.com`, `b1@test.com`, etc.). Esos cuerpos se rechazan antes de guardar nada, así que no generan duplicados. Una celda vacía de Examples llega a Karate como `null`; el escenario la convierte a texto vacío (`''`) para probar el mensaje de campo en blanco.

## 5. Casos ejecutados

En total son 22 escenarios: 6 de POST, 5 de listado, 2 de búsqueda por id, 7 de PUT y 2 de DELETE.

### POST /usuarios

| Caso | Resultado esperado |
| --- | --- |
| Datos válidos | 201, mensaje `Cadastro realizado com sucesso` y `_id` de tipo texto. Un GET posterior cumple el esquema y devuelve el mismo nombre y email |
| Email duplicado | 400, `Este email já está sendo usado` |
| Nombre vacío | 400, `nome não pode ficar em branco` |
| Email sin formato | 400, `email deve ser um email válido` |
| Password vacío | 400, `password não pode ficar em branco` |
| `administrador` distinto de true/false | 400, `administrador deve ser 'true' ou 'false'` |

### GET /usuarios

| Caso | Resultado esperado |
| --- | --- |
| Listar todos | 200. `quantidade` coincide con el tamaño de `usuarios` y cada elemento cumple el esquema |
| Filtrar por el email recién creado | 200, cantidad 1, mismo `_id` y mismo email |
| Email que no existe | 200, cantidad 0 y lista vacía |
| Email con formato inválido | 400, `email deve ser um email válido` |
| `_id=abc` | 200 y lista vacía. Ver hallazgo 1 |

### GET /usuarios/{_id}

| Caso | Resultado esperado |
| --- | --- |
| Id existente | 200, cuerpo igual al esquema, mismo `_id`, nombre y email |
| Id inexistente | 400, `Usuário não encontrado` |

### PUT /usuarios/{_id}

| Caso | Resultado esperado |
| --- | --- |
| Actualizar nombre, password y rol | 200, `Registro alterado com sucesso`. El GET de verificación cumple el esquema y muestra los valores nuevos |
| Email de otro usuario | 400, `Este email já está sendo usado` |
| Nombre, email, password o rol inválidos | 400 y el mismo mensaje por campo que en el POST |
| Id inexistente | 201 y un `_id` nuevo. Ver hallazgo 2 |

### DELETE /usuarios/{_id}

| Caso | Resultado esperado |
| --- | --- |
| Id existente | 200, `Registro excluído com sucesso`. El GET siguiente responde 400, `Usuário não encontrado` |
| Id inexistente | 200, `Nenhum registro excluído` |

## 6. Cómo se validan las respuestas

Los casos de éxito comparan el mensaje exacto de la API y, cuando el cuerpo es un usuario, lo contrastan con `usuario-schema.json`. El listado usa `match each` sobre `response.usuarios`. El PUT, después de actualizar, vuelve a consultar el id y exige el esquema completo más el nombre, el email, la contraseña y el rol nuevos.

Los errores de validación no vienen en `message`. ServeRest responde un objeto con un solo campo, por ejemplo:

```json
{ "nome": "nome não pode ficar em branco" }
```

Cada fila de la tabla indica `campoError` y `mensajeError`. El escenario comprueba tres cosas: status 400, el texto exacto de ese campo y que la respuesta no traiga ningún campo adicional.

## 7. Hallazgos

### 7.1 Filtrar por un _id inexistente no es un error

`GET /usuarios?_id=abc` responde **200** con `quantidade: 0` y `usuarios: []`. La API trata el valor como un filtro sin coincidencias. Un email mal formado, en cambio, sí responde 400. El escenario `Filtrar por un _id inexistente no devuelve error` deja registrada esa diferencia.

### 7.2 PUT sobre un id inexistente crea un usuario

`PUT /usuarios/idQueNoExiste123` con un cuerpo válido responde **201** y `Cadastro realizado com sucesso`. El `_id` del cuerpo es uno nuevo, distinto de `idQueNoExiste123`. ServeRest no rechaza la ruta: inserta el usuario. El escenario comprueba el 201, comprueba que el id cambió y después borra el registro para no dejarlo en la API compartida.

### 7.3 Borrar un id inexistente responde 200

`DELETE /usuarios/idQueNoExiste123` no responde 404. Responde 200 con `Nenhum registro excluído`. El escenario negativo lo fija como contrato observado.

## 8. Resultado

Comando: `mvn test`  
Resultado: 22 escenarios, 0 fallos, 0 errores.  
Duración aproximada: 29 segundos.  
Reporte: `karate-reports/karate-summary.html`

La suite depende de la API pública. Un fallo de red o un cambio de mensaje en ServeRest haría fallar el escenario que compara ese texto.

## 9. Conclusión

El CRUD de usuarios queda cubierto con un feature por endpoint, datos únicos y validación de esquema en las respuestas de éxito. Los negativos comprueban el campo y el mensaje real, no solo el status. Los dos comportamientos menos evidentes —el filtro por `_id` desconocido y el PUT que inserta cuando el id no existe— quedaron escritos como escenarios, con el status que la API devuelve hoy.

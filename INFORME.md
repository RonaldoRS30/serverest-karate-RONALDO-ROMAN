# Informe de pruebas — usuarios ServeRest

Autor: Ronaldo Roman  
API: [https://serverest.dev](https://serverest.dev)  
Fecha: 4 de noviembre de 2026  
Herramienta: Karate 1.4.1, JUnit 5 y Maven

## Qué se probó

El CRUD de `/usuarios`. Quedaron afuera el login, los productos y los carritos.

| Endpoint | Qué se comprobó |
| --- | --- |
| `POST /usuarios` | Alta correcta (201). Email repetido y campos inválidos responden 400 con el mensaje de ese campo |
| `GET /usuarios` | El total coincide con la lista y el primer usuario cumple el esquema. El filtro por email devuelve solo el usuario creado. Un email mal escrito responde 400 |
| `GET /usuarios/{_id}` | 200 si el id existe. 400 y `Usuário não encontrado` si no existe |
| `PUT /usuarios/{_id}` | El cambio queda guardado. No deja usar el email de otro usuario |
| `DELETE /usuarios/{_id}` | Borra al usuario (200). Después, el GET de ese id responde 400 |

Cada alta usa un email distinto (`qa_<uuid>@test.com`) para poder repetir la suite en la API pública.

## Resultado

`mvn clean test`: 22 escenarios, 0 fallos. Duró unos 40 segundos.  
Reporte: `karate-reports/karate-summary.html`

## Lo que no se comporta como uno esperaría

- `GET /usuarios?_id=abc` no responde 400. Responde 200 con la lista vacía. Un email inválido, en el mismo endpoint, sí responde 400.
- `PUT` con un id que no existe no falla: crea el usuario (201) y devuelve otro `_id`. El escenario lo comprueba y después lo borra.
- `DELETE` de un id que no existe responde 200 con `Nenhum registro excluído`, no 404.

Los errores de datos no vienen en `message`. Llegan en el campo que falló, por ejemplo `{ "nome": "nome não pode ficar em branco" }`, y la respuesta trae solo ese campo.

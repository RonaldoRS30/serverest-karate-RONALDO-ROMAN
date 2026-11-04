Feature: Actualizar usuario (PUT /usuarios/{_id})

Background:
  # URL base definida en karate-config.js
  * url baseUrl
  # Clase Java que genera datos únicos
  * def Gen = Java.type('helpers.DataGenerator')
  # Esquema JSON de un usuario, para la consulta de verificación
  * def usuarioSchema = read('classpath:schemas/usuario-schema.json')
  # Feature reutilizable: crea un usuario y devuelve idUsuario y cuerpoUsuario
  * def crearUsuario = read('classpath:helpers/crear-usuario.feature')

@positivo
Scenario: Actualizar un usuario existente
  * def creado = call crearUsuario
  * def idUsuario = creado.idUsuario
  * def cuerpo = creado.cuerpoUsuario

  # Lo actualizamos (cambiamos nombre, password y rol)
  * def nuevoNombre = 'Nombre Actualizado'
  * def cambios = { nome: '#(nuevoNombre)', email: '#(cuerpo.email)', password: 'nuevaPwd456', administrador: 'false' }
  Given path 'usuarios', idUsuario
  And request cambios
  When method put
  Then status 200
  # El mensaje significa: "Registro modificado con éxito"
  And match response.message == 'Registro alterado com sucesso'

  # Verificamos que el cambio quedó guardado y que el cuerpo cumple el esquema
  Given path 'usuarios', idUsuario
  When method get
  Then status 200
  And match response == usuarioSchema
  And match response.nome == nuevoNombre
  And match response.email == cuerpo.email
  And match response.password == 'nuevaPwd456'
  And match response.administrador == 'false'

@negativo
Scenario: No permite actualizar con el email de otro usuario
  * def uno = call crearUsuario
  * def dos = call crearUsuario

  # Intentamos ponerle al usuario dos el email del usuario uno
  * def cambios = { nome: 'Usuario Dos', email: '#(uno.cuerpoUsuario.email)', password: 'teste123', administrador: 'true' }
  Given path 'usuarios', dos.idUsuario
  And request cambios
  When method put
  Then status 400
  # El mensaje significa: "Este email ya está siendo usado"
  And match response.message == 'Este email já está sendo usado'

@negativo
Scenario Outline: Rechaza actualizar con datos inválidos - <caso>
  * def creado = call crearUsuario
  * def idUsuario = creado.idUsuario

  # Los emails son fijos a propósito: la API rechaza el cuerpo antes de guardar
  # el cambio, así que no hay riesgo de duplicado entre ejecuciones.
  # Una celda vacía llega como null; la convertimos a texto vacío para probar el campo en blanco.
  * def enBlanco = function(valor){ return valor == null ? '' : valor }
  * def cambios = { nome: '#(enBlanco(nome))', email: '#(enBlanco(email))', password: '#(enBlanco(password))', administrador: '#(enBlanco(admin))' }
  Given path 'usuarios', idUsuario
  And request cambios
  When method put
  Then status 400
  And match response == '#object'
  # El error llega en el campo que falló, por ejemplo { "nome": "nome não pode ficar em branco" }
  * def mensajeRecibido = response[campoError]
  And match mensajeRecibido == mensajeError
  # La respuesta debe traer solo ese campo. El arreglo se arma en JavaScript
  # porque Karate no sustituye la variable dentro de [campoError].
  * def claves = karate.keysOf(response)
  * def claveEsperada = (function(){ return [campoError] })()
  And match claves == claveEsperada

  Examples:
    | caso              | nome | email       | password | admin  | campoError    | mensajeError                              |
    | nombre vacio      |      | b1@test.com | 123      | true   | nome          | nome não pode ficar em branco             |
    | email sin formato | Juan | no-es-email | 123      | true   | email         | email deve ser um email válido            |
    | password vacio    | Juan | b2@test.com |          | true   | password      | password não pode ficar em branco         |
    | admin invalido    | Juan | b3@test.com | 123      | talvez | administrador | administrador deve ser 'true' ou 'false'  |

@negativo
Scenario: PUT con un ID inexistente crea un usuario nuevo
  # Hallazgo: un PUT a un id que no existe no responde error.
  # ServeRest crea un usuario nuevo (201) y devuelve un _id distinto al de la ruta.
  * def cuerpo = { nome: 'Nuevo Por Put', email: '#(Gen.randomEmail())', password: 'teste123', administrador: 'true' }
  Given path 'usuarios', 'idQueNoExiste123'
  And request cuerpo
  When method put
  Then status 201
  # El mensaje significa: "Registro realizado con éxito"
  And match response == { message: 'Cadastro realizado com sucesso', _id: '#string' }
  And match response._id != 'idQueNoExiste123'

  # Limpieza: el PUT dejó un usuario real en la API compartida
  * def idCreado = response._id
  Given path 'usuarios', idCreado
  When method delete
  Then status 200
  And match response.message == 'Registro excluído com sucesso'

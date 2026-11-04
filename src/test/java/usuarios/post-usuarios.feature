Feature: Registrar usuario (POST /usuarios)

Background:
  # URL base definida en karate-config.js
  * url baseUrl
  # Clase Java que genera nombres y emails únicos
  * def Gen = Java.type('helpers.DataGenerator')
  # Cargamos el esquema JSON que describe cómo debe verse un usuario
  * def usuarioSchema = read('classpath:schemas/usuario-schema.json')
  # Feature reutilizable: crea un usuario y devuelve idUsuario y cuerpoUsuario
  * def crearUsuario = read('classpath:helpers/crear-usuario.feature')

@positivo
Scenario: Registrar un usuario con datos válidos
  # Preparamos el cuerpo de la petición con datos únicos
  * def cuerpo = { nome: '#(Gen.randomName())', email: '#(Gen.randomEmail())', password: 'teste123', administrador: 'true' }
  Given path 'usuarios'
  And request cuerpo
  When method post
  # 201 significa "Creado"
  Then status 201
  # El mensaje significa: "Registro realizado con éxito"
  And match response == { message: 'Cadastro realizado com sucesso', _id: '#string' }

  # Verificación cruzada: consultamos el usuario recién creado
  * def idUsuario = response._id
  Given path 'usuarios', idUsuario
  When method get
  Then status 200
  # Validamos la estructura completa contra el esquema
  And match response == usuarioSchema
  # Validamos que los datos guardados sean los que enviamos
  And match response.email == cuerpo.email
  And match response.nome == cuerpo.nome

@negativo
Scenario: No permite registrar un email duplicado
  # El primer usuario se crea con el helper; el segundo reutiliza su email
  * def creado = call crearUsuario
  * def segundo = { nome: 'Usuario Dos', email: '#(creado.cuerpoUsuario.email)', password: 'teste123', administrador: 'true' }
  Given path 'usuarios'
  And request segundo
  When method post
  # 400 significa "Petición incorrecta"
  Then status 400
  # El mensaje significa: "Este email ya está siendo usado"
  And match response.message == 'Este email já está sendo usado'

@negativo
Scenario Outline: Rechaza datos inválidos - <caso>
  # Cada fila de la tabla "Examples" ejecuta este escenario con otros valores.
  # Los emails son fijos a propósito: la API rechaza el cuerpo antes de crear
  # el usuario, así que no hay riesgo de duplicado entre ejecuciones.
  # Una celda vacía llega como null; la convertimos a texto vacío para probar el campo en blanco.
  * def enBlanco = function(valor){ return valor == null ? '' : valor }
  * def cuerpo = { nome: '#(enBlanco(nome))', email: '#(enBlanco(email))', password: '#(enBlanco(password))', administrador: '#(enBlanco(admin))' }
  Given path 'usuarios'
  And request cuerpo
  When method post
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
    | nombre vacio      |      | a1@test.com | 123      | true   | nome          | nome não pode ficar em branco             |
    | email sin formato | Juan | no-es-email | 123      | true   | email         | email deve ser um email válido            |
    | password vacio    | Juan | a2@test.com |          | true   | password      | password não pode ficar em branco         |
    | admin invalido    | Juan | a3@test.com | 123      | talvez | administrador | administrador deve ser 'true' ou 'false'  |

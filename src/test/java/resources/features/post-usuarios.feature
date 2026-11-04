Feature: Registrar usuario (POST /usuarios)

Background:
  * url baseUrl
  * def Gen = Java.type('karate.util.DataGenerator')
  * def usuarioSchema = read('classpath:resources/request/usuario-schema.json')
  * def crearUsuario = read('classpath:resources/helpers/crear-usuario.feature')

@positivo
Scenario: Registrar un usuario con datos válidos
  * def cuerpo = { nome: '#(Gen.randomName())', email: '#(Gen.randomEmail())', password: 'teste123', administrador: 'true' }
  Given path 'usuarios'
  And request cuerpo
  When method post
  Then status 201
  And match response == { message: 'Cadastro realizado com sucesso', _id: '#string' }

  * def idUsuario = response._id
  Given path 'usuarios', idUsuario
  When method get
  Then status 200
  And match response == usuarioSchema
  And match response.email == cuerpo.email
  And match response.nome == cuerpo.nome

@negativo
Scenario: No permite registrar un email duplicado
  * def creado = call crearUsuario
  * def segundo = { nome: 'Usuario Dos', email: '#(creado.cuerpoUsuario.email)', password: 'teste123', administrador: 'true' }
  Given path 'usuarios'
  And request segundo
  When method post
  Then status 400
  And match response.message == 'Este email já está sendo usado'

@negativo
Scenario Outline: Rechaza datos inválidos - <caso>
  * def enBlanco = function(valor){ return valor == null ? '' : valor }
  * def cuerpo = { nome: '#(enBlanco(nome))', email: '#(enBlanco(email))', password: '#(enBlanco(password))', administrador: '#(enBlanco(admin))' }
  Given path 'usuarios'
  And request cuerpo
  When method post
  Then status 400
  And match response == '#object'
  * def mensajeRecibido = response[campoError]
  And match mensajeRecibido == mensajeError
  * def claves = karate.keysOf(response)
  # Karate no sustituye la variable dentro de [campoError]
  * def claveEsperada = (function(){ return [campoError] })()
  And match claves == claveEsperada

  Examples:
    | caso              | nome | email       | password | admin  | campoError    | mensajeError                              |
    | nombre vacio      |      | a1@test.com | 123      | true   | nome          | nome não pode ficar em branco             |
    | email sin formato | Juan | no-es-email | 123      | true   | email         | email deve ser um email válido            |
    | password vacio    | Juan | a2@test.com |          | true   | password      | password não pode ficar em branco         |
    | admin invalido    | Juan | a3@test.com | 123      | talvez | administrador | administrador deve ser 'true' ou 'false'  |

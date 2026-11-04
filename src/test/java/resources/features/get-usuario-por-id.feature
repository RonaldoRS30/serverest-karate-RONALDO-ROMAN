Feature: Buscar usuario por ID (GET /usuarios/{_id})

Background:
  * url baseUrl
  * def usuarioSchema = read('classpath:resources/request/usuario-schema.json')
  * def crearUsuario = read('classpath:resources/helpers/crear-usuario.feature')

@positivo
Scenario: Buscar un usuario existente por su ID
  * def creado = call crearUsuario
  * def idUsuario = creado.idUsuario
  * def cuerpo = creado.cuerpoUsuario

  Given path 'usuarios', idUsuario
  When method get
  Then status 200
  And match response == usuarioSchema
  And match response._id == idUsuario
  And match response.email == cuerpo.email
  And match response.nome == cuerpo.nome

@negativo
Scenario: Buscar un usuario con un ID que no existe
  Given path 'usuarios', 'idQueNoExiste123'
  When method get
  Then status 400
  And match response == { message: 'Usuário não encontrado' }

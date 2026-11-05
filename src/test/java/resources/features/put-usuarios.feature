Feature: Actualizar usuario (PUT /usuarios/{_id})

Background:
  * url baseUrl
  * def Gen = Java.type('karate.util.DataGenerator')
  * def usuarioSchema = read('classpath:resources/request/usuario-schema.json')
  * def crearUsuario = read('classpath:resources/helpers/crear-usuario.feature')

@positivo
Scenario: Actualizar un usuario existente
  * def creado = call crearUsuario
  * def idUsuario = creado.idUsuario
  * def cuerpo = creado.cuerpoUsuario

  * def nuevoNombre = 'Nombre Actualizado'
  * def cambios = { nome: '#(nuevoNombre)', email: '#(cuerpo.email)', password: 'nuevaPwd456', administrador: 'false' }
  Given path 'usuarios', idUsuario
  And request cambios
  When method put
  Then status 200
  And match response.message == 'Registro alterado com sucesso'

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

  * def cambios = { nome: 'Usuario Dos', email: '#(uno.cuerpoUsuario.email)', password: 'teste123', administrador: 'true' }
  Given path 'usuarios', dos.idUsuario
  And request cambios
  When method put
  Then status 400
  And match response.message == 'Este email já está sendo usado'

@negativo
Scenario Outline: Rechaza actualizar con datos inválidos (CSV) - <caso>
  * def creado = call crearUsuario
  * def idUsuario = creado.idUsuario

  * def enBlanco = function(valor){ return valor == null ? '' : valor }
  * def cambios = { nome: '#(enBlanco(nome))', email: '#(enBlanco(email))', password: '#(enBlanco(password))', administrador: '#(enBlanco(admin))' }
  Given path 'usuarios', idUsuario
  And request cambios
  When method put
  Then status 400
  And match response == '#object'
  * def mensajeRecibido = response[campoError]
  And match mensajeRecibido == mensajeError
  * def claves = karate.keysOf(response)
  # Karate no sustituye la variable dentro de [campoError]
  * def claveEsperada = (function(){ return [campoError] })()
  And match claves == claveEsperada

  Examples:
    | karate.read('classpath:resources/data/usuarios-invalidos.csv') |

@negativo
Scenario: PUT con un ID inexistente crea un usuario nuevo
  # Un id que no existe no falla: ServeRest crea el usuario y devuelve otro _id
  * def cuerpo = { nome: 'Nuevo Por Put', email: '#(Gen.randomEmail())', password: 'teste123', administrador: 'true' }
  Given path 'usuarios', 'idQueNoExiste123'
  And request cuerpo
  When method put
  Then status 201
  And match response == { message: 'Cadastro realizado com sucesso', _id: '#string' }
  And match response._id != 'idQueNoExiste123'

  * def idCreado = response._id
  Given path 'usuarios', idCreado
  When method delete
  Then status 200
  And match response.message == 'Registro excluído com sucesso'

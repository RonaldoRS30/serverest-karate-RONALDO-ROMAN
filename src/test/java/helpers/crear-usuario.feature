Feature: Helper - crear usuario

  Scenario: Crear un usuario válido y devolver sus datos
    # Genera datos únicos para que cada llamada cree un usuario distinto
    * def Gen = Java.type('helpers.DataGenerator')
    * def cuerpoUsuario = { nome: '#(Gen.randomName())', email: '#(Gen.randomEmail())', password: 'teste123', administrador: 'true' }
    Given url baseUrl
    And path 'usuarios'
    And request cuerpoUsuario
    When method post
    Then status 201
    # Estas variables quedan disponibles para quien llame a este feature
    * def idUsuario = response._id

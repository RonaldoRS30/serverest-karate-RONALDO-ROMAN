@ignore
Feature: Helper - crear usuario

  Scenario: Crear un usuario válido y devolver sus datos
    * def Gen = Java.type('karate.util.DataGenerator')
    * def cuerpoUsuario = { nome: '#(Gen.randomName())', email: '#(Gen.randomEmail())', password: 'teste123', administrador: 'true' }
    Given url baseUrl
    And path 'usuarios'
    And request cuerpoUsuario
    When method post
    Then status 201
    * def idUsuario = response._id

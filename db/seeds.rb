# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Doorkeeper::Application.create(name: "redex_app", uid: "d379011c5fc6ce6d8a78d75e7e58d3dba72a837a256712a4d72650f50f22b444", secret: "9d203d753836cae1fa527a12ca88d7be5e83a439305589a37c0e7bbf9f23f613", redirect_uri: "urn:ietf:wg:oauth:2.0:oob")

Role.create([{ name: 'Admin' }, { name: 'Courrier' }, { name: 'CompanyManager' }, { name: 'OfficeManager' },{ name: 'OfficeAsistant'},{ name: 'Auditor'}])

User.create([ {
              email: 'vanmartc@mail.com',
              name: 'van Medellin',
              password: '1234321',
              roles: [Role.find_by_name('Admin')]},
              {
              email: 'donjorge@mail.com',
              name: 'Don Jorge Medellin',
              password: '1234321',
              roles: [Role.find_by_name('Admin'),Role.find_by_name('CompanyManager')]},
              {
              email: 'redexmanizales@une.net.co',
              name: 'Don Uriel',
              password: 'casa20152015',
              roles: [Role.find_by_name('OfficeManager'), Role.find_by_name('Admin')]},
              {
              latitude: '5.06764833333333',
              longitude: '-75.5162466666667',
              location: 'cra 43',
              email: 'oliver@redex.com',
              name: 'JOSE OLIVER MARIN PINEDA',
              password: '1234321',
              mail_delivery_office_id: 1,
              roles: [Role.find_by_name('Courrier')]},
              {
              latitude: '5.06764833333333',
              longitude: '-75.5162466666667',
              location: 'cra 43',
              email: 'mensajero1@redex.com',
              name: 'Mensajero 1',
              password: 'men012017',
              mail_delivery_office_id: 1,
              roles: [Role.find_by_name('Courrier')]},
              {
              latitude: '5.06764833333333',
              longitude: '12',
              location: 'cra 43',
              email: 'mensajero2@redex.com',
              name: 'Mensajero 2',
              password: 'men022017',
              mail_delivery_office_id: 1,
              roles: [Role.find_by_name('Courrier')]},
              {
              latitude: '5.06764833333333',
              longitude: '-75.5162466666667',
              location: 'cra 43',
              email: 'mensajero3@redex.com',
              name: 'Mensajero 3',
              password: 'men032017',
              mail_delivery_office_id: 1,
              roles: [Role.find_by_name('Courrier')]},
              {
              latitude: '5.06764833333333',
              longitude: '-75.5162466666667',
              location: 'cra 43',
              email: 'mensajero4@redex.com',
              name: 'Mensajero 4',
              password: 'men042017',
              mail_delivery_office_id: 1,
              roles: [Role.find_by_name('Courrier')]},
              {
              latitude: '5.06764833333333',
              longitude: '-75.5162466666667',
              location: 'cra 43',
              email: 'mensajero5@redex.com',
              name: 'Mensajero 5',
              password: 'men052017',
              mail_delivery_office_id: 1,
              roles: [Role.find_by_name('Courrier')]},
              ])

MailDeliveryCompany.create({
    name: 'Redex principal medellin',
    address: 'Cl. 43 #6739, Medellín, Antioquia, Colombia',
    email: 'redexprincipal@mail.com',
    phone: '4442222',
    user_id: 2
  })

MailDeliveryOffice.create({
    name: 'Redex manizales',
    address: 'carrera 25 con calle 25 manizales',
    email: 'redexmanizales@mail.com',
    phone: '8848882',
    user_id: 3,
    mail_delivery_company_id: 1
  })

 U = User.where(id: 3).last
 U.mail_delivery_office_id = 1
 U.save

 CourriersLocation.create({
    latitude: '5.4324',
    longitude: '-54.32423',
    location_type: 'Requested',
    user_id: 4

  })



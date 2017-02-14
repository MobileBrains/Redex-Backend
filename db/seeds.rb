# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Doorkeeper::Application.create(name: "redex_app", uid: "d379011c5fc6ce6d8a78d75e7e58d3dba72a837a256712a4d72650f50f22b444", secret: "9d203d753836cae1fa527a12ca88d7be5e83a439305589a37c0e7bbf9f23f613", redirect_uri: "urn:ietf:wg:oauth:2.0:oob")

Role.create([{ name: 'Admin' }, { name: 'Courrier' }, { name: 'CompanyManager' }, { name: 'OfficeManager' }])

User.create([{ email: 'admin@mail.com', name: 'JOSE OLIVER MARIN PINEDA', password: '1234321', roles: [Role.find_by_name('Admin')] }])

use uber;



// Estructura de colecciones:
// - conductores: {_id:ObjectId, nombre, apellido, licencia, telefono, email, ultima_actividad}
// - vehiculos: {id_vehiculo:ObjectId, id_conductor:ObjectId, marca, patente, modelo, año, color}
// - viajes: {id_conductor:ObjectId, id_vehiculo:ObjectId, punto_partida, destino, distancia, tiempo_viaje, estado, fecha_hora_inicio, fecha_hora_final}
// - usuarios: {nombre, apellido, email, telefono, reseñasDadas:[{id_viaje:ObjectId, calificacion, comentario, fecha}], pagos:[{id_viaje:ObjectId, fechaPago, total, estado, metodoDePago}]}

// Insert inicial de conductores
 db.conductores.insertMany([
  {
    _id: ObjectId(),
    nombre: "Carlos",
    apellido: "García",
    licencia: "AB123456",
    telefono: "+541100011122",
    email: "carlos.garcia@example.com",
    ultima_actividad: ISODate("2024-11-12T08:30:00Z")
  },
  {
    _id: ObjectId(),
    nombre: "Laura",
    apellido: "Pérez",
    licencia: "CD789012",
    telefono: "+541100033344",
    email: "laura.perez@example.com",
    ultima_actividad: ISODate("2024-11-11T10:15:00Z")
  },
  {
    _id: ObjectId(),
    nombre: "Pedro",
    apellido: "Sánchez",
    licencia: "EF345678",
    telefono: "+541100055566",
    email: "pedro.sanchez@example.com",
    ultima_actividad: ISODate("2024-11-10T09:45:00Z")
  },
  {
    _id: ObjectId(),
    nombre: "Claudia",
    apellido: "López",
    licencia: "GH901234",
    telefono: "+541100077788",
    email: "claudia.lopez@example.com",
    ultima_actividad: ISODate("2024-11-09T11:00:00Z")
  },
  {
    _id: ObjectId(),
    nombre: "Esteban",
    apellido: "Martínez",
    licencia: "IJ567890",
    telefono: "+541100099900",
    email: "esteban.martinez@example.com",
    ultima_actividad: ISODate("2024-11-08T12:30:00Z")
  }
]);

// Insert inicial de vehículos
 db.vehiculos.insertMany([
  {
    id_vehiculo: ObjectId(),
    id_conductor: db.conductores.findOne({ nombre: "Carlos" })._id,
    marca: "Toyota",
    patente: "ABC123",
    modelo: "Corolla",
    año: 2018,
    color: "Blanco"
  },
  {
    id_vehiculo: ObjectId(),
    id_conductor: db.conductores.findOne({ nombre: "Laura" })._id,
    marca: "Honda",
    patente: "DEF456",
    modelo: "Civic",
    año: 2020,
    color: "Negro"
  },
  {
    id_vehiculo: ObjectId(),
    id_conductor: db.conductores.findOne({ nombre: "Pedro" })._id,
    marca: "Ford",
    patente: "GHI789",
    modelo: "Focus",
    año: 2019,
    color: "Azul"
  },
  {
    id_vehiculo: ObjectId(),
    id_conductor: db.conductores.findOne({ nombre: "Claudia" })._id,
    marca: "Chevrolet",
    patente: "JKL012",
    modelo: "Cruze",
    año: 2021,
    color: "Gris"
  },
  {
    id_vehiculo: ObjectId(),
    id_conductor: db.conductores.findOne({ nombre: "Esteban" })._id,
    marca: "Nissan",
    patente: "MNO345",
    modelo: "Sentra",
    año: 2017,
    color: "Rojo"
  }
]);

// Insert inicial de viajes
 db.viajes.insertMany([
  {
    id_conductor: db.conductores.findOne({ nombre: "Carlos" })._id,
    id_vehiculo: db.vehiculos.findOne({ patente: "ABC123" })._id,
    punto_partida: "Av. Libertador 5000, Buenos Aires",
    destino: "Calle 25 de Mayo 1200, Buenos Aires",
    distancia: 10,
    tiempo_viaje: 15,
    estado: "Completado",
    fecha_hora_inicio: new Date("2024-10-01T08:00:00"),
    fecha_hora_final: new Date("2024-10-01T08:15:00")
  },
  {
    id_conductor: db.conductores.findOne({ nombre: "Laura" })._id,
    id_vehiculo: db.vehiculos.findOne({ patente: "DEF456" })._id,
    punto_partida: "Av. Corrientes 3000, Buenos Aires",
    destino: "Calle San Martín 4000, Buenos Aires",
    distancia: 8,
    tiempo_viaje: 12,
    estado: "Completado",
    fecha_hora_inicio: new Date("2024-10-01T09:00:00"),
    fecha_hora_final: new Date("2024-10-01T09:12:00")
  },
  {
    id_conductor: db.conductores.findOne({ nombre: "Laura" })._id,
    id_vehiculo: db.vehiculos.findOne({ patente: "DEF456" })._id,
    punto_partida: "Av. de Mayo 2000, Buenos Aires",
    destino: "Calle Paseo Colón 500, Buenos Aires",
    distancia: 5,
    tiempo_viaje: 10,
    estado: "Completado",
    fecha_hora_inicio: new Date("2024-10-01T10:00:00"),
    fecha_hora_final: new Date("2024-10-01T10:10:00")
  },
  {
    id_conductor: db.conductores.findOne({ nombre: "Pedro" })._id,
    id_vehiculo: db.vehiculos.findOne({ patente: "GHI789" })._id,
    punto_partida: "Calle Florida 100, Buenos Aires",
    destino: "Av. 9 de Julio 3000, Buenos Aires",
    distancia: 2,
    tiempo_viaje: 5,
    estado: "Completado",
    fecha_hora_inicio: new Date("2024-10-01T11:00:00"),
    fecha_hora_final: new Date("2024-10-01T11:05:00")
  },
  {
    id_conductor: db.conductores.findOne({ nombre: "Claudia" })._id,
    id_vehiculo: db.vehiculos.findOne({ patente: "JKL012" })._id,
    punto_partida: "Av. Rivadavia 6000, Buenos Aires",
    destino: "Av. Callao 1000, Buenos Aires",
    distancia: 7,
    tiempo_viaje: 10,
    estado: "Completado",
    fecha_hora_inicio: new Date("2024-11-01T12:00:00"),
    fecha_hora_final: new Date("2024-11-01T12:10:00")
  }
]);

// Insert inicial de usuarios con reseñas y pagos
 db.usuarios.insertMany([
  {
    nombre: "Juan",
    apellido: "Pérez",
    email: "juan.perez@example.com",
    telefono: "123456789",
    reseñasDadas: [
      {
        id_viaje: ObjectId("672fca1c8158a9d1c10d81ef"),
        calificacion: 5,
        comentario: "Excelente servicio!",
        fecha: new Date("2024-10-01")
      }
    ],
    pagos: [
      {
        id_viaje: ObjectId("672fca1c8158a9d1c10d81ef"),
        fechaPago: new Date("2024-10-01"),
        total: 1500,
        estado: "Completado",
        metodoDePago: "Tarjeta"
      }
    ]
  },
  {
    nombre: "María",
    apellido: "Gómez",
    email: "maria.gomez@example.com",
    telefono: "987654321",
    reseñasDadas: [
      {
        id_viaje: ObjectId("672fca1c8158a9d1c10d81f0"),
        calificacion: 4,
        comentario: "Buen viaje, conductor amable.",
        fecha: new Date("2024-10-01")
      },
      {
        id_viaje: ObjectId("672fca1c8158a9d1c10d81f1"),
        calificacion: 4,
        comentario: "Buen viaje, conductor amable x2.",
        fecha: new Date("2024-10-01")
      }
    ],
    pagos: [
      {
        id_viaje: ObjectId("672fca1c8158a9d1c10d81f0"),
        fechaPago: new Date("2024-10-01"),
        total: 700,
        estado: "Completado",
        metodoDePago: "Efectivo"
      },
      {
        id_viaje: ObjectId("672fca1c8158a9d1c10d81f1"),
        fechaPago: new Date("2024-10-01"),
        total: 700,
        estado: "Completado",
        metodoDePago: "Efectivo"
      }
    ]
  },
  {
    nombre: "Carlos",
    apellido: "López",
    email: "carlos.lopez@example.com",
    telefono: "456123789",
    reseñasDadas: [
      {
        id_viaje: ObjectId("672fca1c8158a9d1c10d81f2"),
        calificacion: 3,
        comentario: "Viaje regular, podría mejorar.",
        fecha: new Date("2024-10-01")
      }
    ],
    pagos: [
      {
        id_viaje: ObjectId("672fca1c8158a9d1c10d81f2"),
        fechaPago: new Date("2024-10-01"),
        total: 300,
        estado: "Completado",
        metodoDePago: "Tarjeta"
      }
    ]
  },
  {
    nombre: "Ana",
    apellido: "Torres",
    email: "ana.torres@example.com",
    telefono: "321654987",
    reseñasDadas: [
      {
        id_viaje: ObjectId("672fca1c8158a9d1c10d81f3"),
        calificacion: 2,
        comentario: "No fue lo que esperaba.",
        fecha: new Date("2024-10-01")
      }
    ],
    pagos: [
      {
        id_viaje: ObjectId("672fca1c8158a9d1c10d81f3"),
        fechaPago: new Date("2024-10-01"),
        total: 100,
        estado: "Completado",
        metodoDePago: "Efectivo"
      }
    ]
  }
]);

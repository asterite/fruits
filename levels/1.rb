name "Comienzo"
description %(
  Bievenido a Frutas.
  Usá la mano para mover las frutas de un carril a otro y alimentar a las criaturas.
  Ganás el nivel cuando se termina el tiempo.
  )
time '0:30'
fruits_per_second 0.5
fruits Apple, Orange, Banana
monsters do
  SweetTooth energy: 50, patience: 100
  SweetTooth energy: 50, patience: 100
  SweetTooth energy: 50, patience: 100
  SweetTooth energy: 50, patience: 100
  SweetTooth energy: 50, patience: 100
end
fruits_can_be_grabbed
hide_patience
hide_energy
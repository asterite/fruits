name "Favoritas"
description %(
  Algunas criaturas tienen frutas favoritas.
  Si les das una fruta que no es la favorita, perdés.
  )
time '1:00'
fruits_per_second 0.5
fruits Apple, Banana, Orange
monsters do
  SweetTooth energy: 50, patience: 90, favorite: Apple
  SweetTooth energy: 50, patience: 80
  SweetTooth energy: 50, patience: 70
  SweetTooth energy: 50, patience: 80
  SweetTooth energy: 50, patience: 90
end

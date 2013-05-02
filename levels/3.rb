name "Paciencia"
description %(
  Las criaturas también muestran su paciencia en la barrita roja.
  Si una criatura pierde la paciencia, perdés.
  Cuando una glotona se empacha, otra viene a reemplazarla, con la misma paciencia original que la criatura anterior.
  )
time '1:00'
fruits_per_second 0.5
fruits Apple, Banana, Orange
monsters do
  SweetTooth energy: 20, patience: 90
  SweetTooth energy: 30, patience: 80
  SweetTooth energy: 40, patience: 70
  SweetTooth energy: 80, patience: 20
  SweetTooth energy: 90, patience: 15
end
fruits_can_be_grabbed

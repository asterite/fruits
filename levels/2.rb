name "Glotonas"
description %(
  Cada criatura tiene una barrita verde que dice qué tan llena está.
  Las criaturas rosas son glotonas, quieren empacharse.
  Si una glotona se muere de hambre, perdés.
  )
time '0:30'
fruits_per_second 0.5
fruits Apple, Banana, Orange
monsters do
  SweetTooth energy: 10, patience: 100
  SweetTooth energy: 20, patience: 100
  SweetTooth energy: 30, patience: 100
  SweetTooth energy: 25, patience: 100
  SweetTooth energy: 15, patience: 100
end
hide_patience

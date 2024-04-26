# Attempt to spike use a GUI to configure bot rules

## Experimental sample

- Properties
  - Min Movement
  - Max Movement
  - Max Enemy Level
  - Scan Range
- Variables
  - `Target`
- States
  - State Name `Wander`
    - State Actions:
      - Assign `Direction` = any_vector()
      - Assign `Distance` = rand_range(`Min Movement`, `Max Movement`)
      - Assign `Target` = nearest_entity_in_group("Enemy")
      - Assign `Target Range` = distance_to(`Target`)
      - Assign `Target Level` = level_of(`Target`)
      - Travel(`Direction`, `Distance`)
    - State Transition `Approach Enemy`
      - Conditional Greater Than or Equal
        - `Max Enemy Level`
        - `Target Level`
      - Conditional Greater Than
        - `Scan Range`
        - `Target Range`
  - State Name `Approach Enemy`
    - State Actions
      - Assign `Direction` = vector_to(`Target`)
      - Assign `Target Range` = distance_to(`Target`)
      - Assign `Distance` = min(`Max Movement`, `Target Range`)
      - Travel(`Direction`, `Distance`)
    - State Transition `Melee Attack Enemy`
      - Condition Greater Than or Equal
        - `Melee Range`
        - `Target Range`
    - State Transition `Wander`
      - Condition Greater Than or Equal
        - `Target Range`
        - `Scan Range`
  - State Name `Melee Attack Enemy`
    - State Actions
      - Assign `Target Range` = distance_to(`Target`)
      - Stop()
      - Melee Attack(`Target`)
    - State Transition `Approach Enemy`
      - Condition Greater Than
        - `Target Range`
        - `Melee Range`


## Simplified Design Description

### File IO

#### Format

Json? Yaml?

#### Loading

De-serialize

#### Saving

Serialize

### Live data structure

- Entity
  - Properties
  - Variables
  - States
    - Incumbent Behaviour
      - Movement
    - Conditional Behaviour
      - Behaviour Conditions
        - Condition Properties
      - Behaviour Actions
        - Variable Assignment
        - State Transition

### Front end GUI

#### How live data structure is displayed

#### How Front end is linked to the Live Data

#### Update Data from GUI changes
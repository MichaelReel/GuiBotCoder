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
    - State Actions
      - Assign `Direction` = any_vector()
      - Assign `Distance` = rand_range(`Min Movement`, `Max Movement`)
      - Assign `Target` = nearest_entity_in_group("Enemy")
      - Assign `Target Range` = distance_to(`Target`)
      - Assign `Target Level` = level_of(`Target`)
      - Travel(`Direction`, `Distance`)
    - State Transitions
      - State Transition `Approach Enemy`
        - Conditional greater_or_equal
          - `Max Enemy Level`
          - `Target Level`
        - Conditional greater_than
          - `Scan Range`
          - `Target Range`
  - State Name `Approach Enemy`
    - State Actions
      - Assign `Direction` = vector_to(`Target`)
      - Assign `Target Range` = distance_to(`Target`)
      - Assign `Distance` = min(`Max Movement`, `Target Range`)
      - Travel(`Direction`, `Distance`)
    - State Transitions
      - State Transition `Melee Attack Enemy`
        - Condition greater_or_equal
          - `Melee Range`
          - `Target Range`
      - State Transition `Wander`
        - Condition greater_or_equal
          - `Target Range`
          - `Scan Range`
  - State Name `Melee Attack Enemy`
    - State Actions
      - Assign `Target Range` = distance_to(`Target`)
      - Stop()
      - Melee Attack(`Target`)
    - State Transitions
      - State Transition `Approach Enemy`
        - Condition greater_than
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
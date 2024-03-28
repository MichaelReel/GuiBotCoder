# Attempt to spike use a GUI to configure bot rules

## Experimental sample

- Properties
  - Min Movement
  - Max Movement
  - Scan Range
- Variables
  - Target
- States
  - State Name: Wander
    - Behaviour: Movement: Relative
      - Direction: Any
      - Distance: Range(Min Movement to Max Movement)
    - Behaviour: Scan for Any: Entity
      - Radius: Scan Range
      - Entity Type: Enemy
      - Entity Level less than or equal: 5
      - Assign to: Target
      - State Transition: Approach Enemy
  - State Name: Approach Enemy
    - Behaviour: Movement: Targeted
      - Direction: Target
      - Distance: Max Movement
    - Behaviour: Scan: Target
      - Distance to (Target) less than or equal: Melee Range
      - State Transition: Melee Attack Enemy
    - Behaviour: Scan: Target
      - Distance to (Target) greater than: Scan Range
      - State Transition: Melee Attack Enemy
  - State Name: Melee Attach Enemy
    - Behaviour: Movement: Stop
    - Behaviour: Scan: Target
      - Distance to (Target) less than or equal: Melee Range
      - Action: Attack (Target)
    - Behaviour: Scan: Target
      - Distance to (Target) greater than: Melee Range
      - State Transition: Approach Enemy

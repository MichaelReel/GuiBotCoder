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
        - Conditional greater_or_equal(`Max Enemy Level`, `Target Level`)
        - Conditional greater_than(`Scan Range`, `Target Range`)
  - State Name `Approach Enemy`
    - State Actions
      - Assign `Direction` = vector_to(`Target`)
      - Assign `Target Range` = distance_to(`Target`)
      - Assign `Distance` = min(`Max Movement`, `Target Range`)
      - Travel(`Direction`, `Distance`)
    - State Transitions
      - State Transition `Melee Attack Enemy`
        - Condition greater_or_equal(`Melee Range`, `Target Range`)
      - State Transition `Wander`
        - Condition greater_or_equal(`Target Range`, `Scan Range`)
  - State Name `Melee Attack Enemy`
    - State Actions
      - Assign `Target Range` = distance_to(`Target`)
      - Stop()
      - Melee Attack(`Target`)
    - State Transitions
      - State Transition `Approach Enemy`
        - Condition greater_than(`Target Range`, `Melee Range`)

## Simplified Design Description

### File IO

#### Format

Files will be saved in JSON, would prefer Yaml but JSON is already supported in Godot.

Sample Json:

```json
{
  "version": "0.01",
  "entity_name": "Sample Data Entity",
  "variables": [
    {
      "variable_name": "Target"
    }
  ],
  "properties": [
    {
      "property_name": "Min Movement"
    },
    {
      "property_name": "Max Movement"
    },
    {
      "property_name": "Scan Range"
    },
    {
      "property_name": "Melee Range"
    },
    {
      "property_name": "Target Group"
    }
  ],
  "states": [
    {
      "state_name": "Wander",
      "actions": [
        {
          "action_type": "assignment",
          "assign_variable_name": "Direction",
          "function_name": "any_vector",
          "function_argument_names": []
        },
        {
          "action_type": "assignment",
          "assign_variable_name": "Distance",
          "function_name": "rand_range",
          "function_argument_names": [
            "Min Movement",
            "Max Movement"
          ]
        },
        {
          "action_type": "assignment",
          "assign_variable_name": "Target",
          "function_name": "nearest_entity_in_group",
          "function_argument_names": [
            "Target Group"
          ]
        },
        {
          "action_type": "assignment",
          "assign_variable_name": "Target Range",
          "function_name": "distance_to",
          "function_argument_names": [
            "Target"
          ]
        },
        {
          "action_type": "assignment",
          "assign_variable_name": "Target Level",
          "function_name": "level_of",
          "function_argument_names": [
            "Target"
          ]
        },
        {
          "action_type": "travel",
          "direction_variable_name": "Direction",
          "distance_variable_name": "Distance"
        }
      ],
      "transitions": [
        {
          "target_state_name": "Approach Enemy",
          "conditionals": [
            {
              "condition_function_name": "greater_or_equal",
              "condition_argument_names": [
                "Max Enemy Level",
                "Target Level"
              ]
            },
            {
              "condition_function_name": "greater_than",
              "condition_argument_names": [
                "Scan Range",
                "Target Range"
              ]
            }
          ]
        }
      ]
    },
    {
      "state_name": "Approach Enemy",
      "actions": [
        {
          "action_type": "assignment",
          "assign_variable_name": "Direction",
          "function_name": "vector_to",
          "function_argument_names": [
            "Target"
          ]
        },
        {
          "action_type": "assignment",
          "assign_variable_name": "Target Range",
          "function_name": "distance_to",
          "function_argument_names": [
            "Target"
          ]
        },
        {
          "action_type": "assignment",
          "assign_variable_name": "Distance",
          "function_name": "min",
          "function_argument_names": [
            "Max Movement",
            "Target Range"
          ]
        },
        {
          "action_type": "travel",
          "direction_variable_name": "Direction",
          "distance_variable_name": "Distance"
        }
      ],
      "transitions": [
        {
          "target_state_name": "Melee Attack Enemy",
          "conditionals": [
            {
              "condition_function_name": "greater_or_equal",
              "condition_argument_names": [
                "Melee Range",
                "Target Range"
              ]
            }
          ]
        },
        {
          "target_state_name": "Wander",
          "conditionals": [
            {
              "condition_function_name": "greater_or_equal",
              "condition_argument_names": [
                "Target Range",
                "Scan Range"
              ]
            }
          ]
        }
      ]
    },
    {
      "state_name": "Melee Attack Enemy",
      "actions": [
        {
          "action_type": "assignment",
          "assign_variable_name": "Target Range",
          "function_name": "distance_to",
          "function_argument_names": [
            "Target"
          ]
        },
        {
          "action_type": "stop"
        },
        {
          "action_type": "perform",
          "function_name": "melee_attack",
          "function_argument_names": [
            "Target"
          ]
        }
      ],
      "transitions": [
        {
          "target_state_name": "Approach Enemy",
          "conditionals": [
            {
              "condition_function_name": "greater_than",
              "condition_argument_names": [
                "Target Range",
                "Melee Range"
              ]
            }
          ]
        }
      ]
    }
  ]
}
```

#### Loading

De-serialize

#### Saving

Serialize

### Live data structure

- Entity
  - Properties
  - Variables
  - States
    - State
      - Action
        - Setting Local Variables
        - Setting Machine Variables
        - Movement
        - Attacks
      - State Transitions
        - State Transition
          - Condition For Change

### Front end GUI

#### How live data structure is displayed

#### How Front end is linked to the Live Data

#### Update Data from GUI changes
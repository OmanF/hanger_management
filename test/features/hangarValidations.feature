Feature: Manage Hangars (success/failure)
    # When posting, and removing, planes all cases in this feature require the IDs provided to the respective endpoints to be valid

    Background: Hangars state
        Given two EMPTY hangars exist

    Rule: Hangar plane capacity limit validation

        Scenario Outline: Hangar plane capacity
            Given the first hangar has <initialHangarCapacity> valid planes carrying no missiles
            When I store a valid plane carrying no missiles to the first hangar
            Then the operation should be <outcome>

            Examples:
                | initialHangarCapacity | outcome                   |
                | 0                     | success                   |
                | 9                     | success                   |
                | 10                    | hangarPlanesCapacityError |

    Rule: Hangar missile capacity limit validation

        Scenario: Hangar missile capacity not breached
            When I iteratively store FULLY LOADED AM-999 planes 1 through 4 in the first hangar
            Then the should succeed

        Scenario: Hangar missile capacity breached
            Given the first hangar has FULLY LOADED AM-999 planes 1 through 4
            When I store a fifth AM-999 plane in the first hangar carrying <additionalMissiles> missiles
            Then the operation should be <outcome>

            Examples:
                | additionalMissiles | outcome                     |
                | 1                  | success                     |
                | 2                  | success                     |
                | 3                  | success                     |
                | 4                  | success                     |
                | 5                  | hangarMissilesCapacityError |

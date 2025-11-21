Feature: Manage Hangers

    Background: Hangers state
        Given there are two hangers
        And the hangers are empty

    Rule: Up to 10 planes per hanger

        Scenario Outline: Adding planes to hanger with varying existing plane counts
            Given the first hanger has <existingPlanes> planes carrying no missiles
            When I position a valid plane carrying no missiles to the first hanger
            Then the operation should be <outcome>

            Examples:
                | existingPlanes | outcome |
                | 0              | success |
                | 9              | success |
                | 10             | failure |

    Rule: Up to 100 missile per hanger
    # TODO: Implement

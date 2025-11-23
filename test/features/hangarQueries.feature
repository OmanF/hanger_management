Feature: Query hangars

    Background: Hangars state
        Given five EMPTY hangars exist

    Rule: Query all hangars
        # The `GET /hangars` endpoint should ALWAYS respond successfully, regardless of hangars' states

        Scenario: Query all hangars when all are empty
            When I run a "GET /hangars" request
            Then the operation should succeed

        Scenario: Query all hangars when some are at capacity
            Given a random number of hangars are at random VALID capacity
            When I run a "GET /hangars" request
            Then the operation should succeed

    Rule: Query specific hangar

        Scenario Outline: Query specific hangar by ID
            Given a random number of hangars are at random VALID capacity
            When I run a "GET /hangars/{id}" request for hangar ID <hangarId>
            Then the operation should be <outcome>

            Examples:
                | hangarId | outcome             |
                | 0        | success             |
                | 1        | success             |
                | 2        | success             |
                | 3        | success             |
                | 4        | success             |
                | 5        | hangarNotFoundError |
                # Since hangar ID is a runtime user input, the following cases **are** possible, and to be handled!
                # `null` means actually null value, i.e., no list at all
                | `null`   | invalidInputError   |
                | -1       | invalidInputError   |
                | 1.1      | invalidInputError   |
                | "a"      | invalidInputError   |

    Rule: Query planes in specific hangar
        # As with the `/hangars` endpoint, the `GET /hangars/{id}/planes` should ALWAYS respond successfully, regardless of hangars' states, for valid hangar IDs
        # Since we've already tested hangar ID validity in the previous rule, all queries from here on assume valid hangar ID

        Scenario: Query planes in specific empty hangar
            When I run a "GET /hangars/{id}/planes" request for a valid hangar ID
            Then the operation should succeed

        Scenario: Query planes in specific hangar with some planes
            Given ALL hangars are at random VALID capacity
            When I run a "GET /hangars/{id}/planes" request for a valid hangar ID
            Then the operation should succeed

    Rule: Query specific plane in specific hangar
        # Since we've already tested hangar ID validity in the previous rule, all queries from here on assume valid hangar ID

        Scenario: Query specific plane in hangar when hangar is empty
            Given a specific hangar is EMPTY
            When I run a "GET /hangars/{hId}/planes/{pId}" request for hangar ID 0 and plane ID 0
            Then the operation should return a planeNotFoundError

        Scenario Outline: Query specific plane in hangar when hangar has some planes
            Given the first hangar is at FULL VALID capacity
            When I run a "GET /hangars/0/planes/{pId}" request for plane ID <planeId>
            Then the operation should be <outcome>

            Examples:
                | planeId | outcome            |
                | 0       | success            |
                | 1       | success            |
                | 9       | success            |
                | 10      | planeNotFoundError |
                # Since plane ID is a runtime user input, the following cases **are** possible, and to be handled!
                # `null` means actually null value, i.e., no list at all
                | `null`  | invalidInputError  |
                | -1      | invalidInputError  |
                | 1.1     | invalidInputError  |
                | "a"     | invalidInputError  |

    Rule: Query missiles on specific plane in specific hangar
        # As with the `/hangars` and `/hangars/{id}/planes` endpoints, the `GET /hangars/{id}/planes/{pId}/missiles` should ALWAYS respond successfully, for valid hangar and plane IDs
        # Since we've already tested hangar and plane ID validity in the previous rules, all queries from here on assume valid hangar and plane ID

        Scenario: Query missiles on specific plane when plane has no missiles
            Given the first hangar has a plane at ID 0 with NO missiles
            When I run a "GET /hangars/0/planes/0/missiles" request
            Then the operation should succeed

        Scenario: Query missiles on specific plane when plane has some missiles
            Given the first hangar has a plane at ID 0 with SOME missiles
            When I run a "GET /hangars/0/planes/0/missiles" request
            Then the operation should succeed

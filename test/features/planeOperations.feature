Feature: Add plane to hanger

    Background:
        # Most cases in this feature require only one hanger, but since some require two, we create two hangers from the get-go        Given two hangers exist
        Given there are two hangers
        And the hangers are empty

    Rule: Valid plane name

        Scenario Outline: Adding planes with various names
            When I position a plane named "<planeName>" with <missileCount> unique missiles in the first hanger
            Then the operation should be <outcome>

            Examples:
                | planeName | missileCount | outcome |
                | AM-101    | 12           | success |
                | ILX       | 10           | success |
                | EUF       | 10           | success |
                | AM-333    | 6            | success |
                | DEUS-666  | 6            | success |
                | AM-999    | 24           | success |
                # `null` means actually null value, not the string "null"
                | `null`    | 3            | failure |
                # Empty string
                |           | 3            | failure |
                # All whitespace string is an invalid name
                |           | 3            | failure |
                # Emoji name doubles as invalid name, as well as testing system's behavior towards non-ASCII characters
                | ✈️-101    | 3            | failure |

    Rule: Valid missiles

        Scenario Outline: Adding plane with various missiles
            When I position a plane named "AM-101" with missiles list: <missileList> in the first hanger
            Then the operation should be <outcome>

            Examples:
                | missileList                      | outcome |
                | []                               | success |
                | [1]                              | success |
                | [1, 20, 300, 4000, 5000000000]   | success |
                # `null` means actually null value, i.e., no list at all
                | `null`                           | failure |
                | [0]                              | failure |
                | [-1]                             | failure |
                | [1.1]                            | failure |
                | ["a"]                            | failure |
                | [123456789012345678901234567890] | failure |

    Rule: Valid plane missile count

        Scenario Outline: Adding planes with various missile counts
            When I position a valid plane named "AM-101" with <missileCount> unique missiles in the first hanger
            Then the operation should be <outcome>

            Examples:
                # Existing, but empty, missiles list is already tested in previous rule
                | missileCount | outcome |
                | 5            | success |
                | 12           | success |
                | 13           | failure |

    Rule: Missile uniqueness

        Scenario Outline: Planes missiles should be unique within plane
            When I position a plane named "AM-101" with the following missiles list: <missileList> in the first hanger
            Then the operation should be <outcome>

            Examples:
                # Existing, but empty, missiles list is already tested in previous rule
                | missileList | outcome |
                | [1, 2]      | success |
                | [2, 2]      | failure |

        Scenario Outline: Planes missiles should be system-wide unique
            When I position a plane named "AM-101" with missiles list: <missileList1> in the first hanger
            And I position a plane named "ILX" with missiles list: <missileList2> in the second hanger
            Then positioning the SECOND plane should be <outcome>

            Examples:
                | missileList1 | missileList2 | outcome |
                | []           | []           | success |
                | []           | [1, 2]       | success |
                | [1, 2]       | []           | success |
                | [1, 2]       | [3, 4]       | success |
                | [5, 6]       | [6, 7]       | failure |

    Rule: Remove a plane
    # TODO: Implement

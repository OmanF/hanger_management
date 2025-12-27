Feature: Store plane in hangar (success/failure)

    Background: Hangars state
        Given five EMPTY hangars exist

    Rule: Plane name validation

        Scenario Outline: Storing planes with various names
            When I store a plane named "<planeName>" with <planeCapacity> unique missiles in EITHER hangar
            Then the operation should be <outcome>

            Examples:
                | planeName | planeCapacity | outcome           |
                | AM-101    | 12            | success           |
                | ILX       | 10            | success           |
                | EUF       | 10            | success           |
                | AM-333    | 6             | success           |
                | DEUS-666  | 6             | success           |
                | AM-999    | 24            | success           |
                | ""        | 3             | planeNameError    |
                | "   "     | 3             | planeNameError    |
                | ✈️-101    | 3             | planeNameError    |
                # Following cases are not possible in F# due to its type system, here for completeness
                # `null` means actually null value, i.e., no list at all
                | `null`    | 3             | invalidInputError |

    Rule: Plane missiles content validation

        Scenario Outline: Storing plane with various missiles
            When I loop through allowed planes
            And each has the missiles list: <missileList>
            And I store the plane in EITHER hangar
            Then the operation should be <outcome>

            Examples:
                | missileList                      | outcome                |
                | []                               | success                |
                | [1]                              | success                |
                | [1, 20, 300, 4000, 5000000000]   | success                |
                | [0]                              | planeMissilesListError |
                | [-1]                             | planeMissilesListError |
                | [123456789012345678901234567890] | planeMissilesListError | # Each single missile ID must fit an `int64`
                # Following cases are not possible in F# due to its type system, here for completeness
                # `null` means actually null value, i.e., no list at all
                | `null`                           | invalidInputError      |
                | [1.1]                            | invalidInputError      |
                | ["a"]                            | invalidInputError      |

    Rule: Plane missiles capacity validation

        Scenario Outline: Storing planes with various missiles capacities
            When I store a plane named "<planeName>" with <planeCapacity> unique missiles in EITHER hangar
            Then the operation should be <outcome>

            Examples:
                # Existing, but empty, missiles list is already tested in previous rule
                | planeName | planeCapacity | outcome                    |
                | AM-101    | 5             | success                    |
                | AM-101    | 12            | success                    |
                | AM-101    | 13            | planeMissilesCapacityError |
                | ILX       | 5             | success                    |
                | ILX       | 10            | success                    |
                | ILX       | 11            | planeMissilesCapacityError |
                | EUF       | 5             | success                    |
                | EUF       | 10            | success                    |
                | EUF       | 11            | planeMissilesCapacityError |
                | AM-333    | 3             | success                    |
                | AM-333    | 6             | success                    |
                | AM-333    | 7             | planeMissilesCapacityError |
                | DEUS-666  | 3             | success                    |
                | DEUS-666  | 6             | success                    |
                | DEUS-666  | 7             | planeMissilesCapacityError |
                | AM-999    | 20            | success                    |
                | AM-999    | 24            | success                    |
                | AM-999    | 25            | planeMissilesCapacityError |

    Rule: Plane missiles uniqueness validation

        Scenario Outline: Planes missiles should be unique among themselves
            When I store a plane named "AM-101" with the following missiles list: <missileList> in EITHER hangar
            Then the operation should be <outcome>

            Examples:
                # Existing, but empty, missiles list is already tested in previous rule
                | missileList | outcome                      |
                | [1, 2]      | success                      |
                | [2, 2]      | planeMissilesUniquenessError |

        Scenario Outline: Planes missiles should be system-wide unique
            When I store a plane named "AM-101" with missiles list: <missileList1> in the first hangar
            And I store a plane named "ILX" with missiles list: <missileList2> in the second hangar
            Then storing the SECOND plane should be <outcome>

            Examples:
                | missileList1 | missileList2 | outcome                      |
                | []           | []           | success                      |
                | []           | [1, 2]       | success                      |
                | [1, 2]       | []           | success                      |
                | [1, 2]       | [3, 4]       | success                      |
                | [5, 6]       | [6, 7]       | planeMissilesUniquenessError |

    Rule: Disembark plane validation

        Scenario: Disembarking an empty hangar fails
            When I disembark a plane from EITHER hangar
            Then the operation should fail

        Scenario: Disembarking plane from hangar
            Given the first hangar has any valid plane stored inside
            When I disembark the plane
            Then the operation should succeed

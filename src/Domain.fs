namespace HangerManager

// #region Toy project disclaimer
// Note that this is a simplistic, toy, project
// There is no user validation, no authentication/authorization
// All relevant types are public and can be instantiated by any calling function without confirmation
// In production, constructor would be `private` and take a `Role` input parameter, where only certain roles even have the permission to construct
// With a proper authN/authZ system in place, to verify a user *is* who they claim *to be*
// #endregion

[<AutoOpen>]
module Domain =
    type Errors =
        | PlaneNameError of string
        | PlaneMissilesListError of string
        | PlaneMissilesCapacityError of string
        | PlaneMissilesUniquenessError of string
        | PlaneDisembarkError of string
        | HangarMissilesCapacityError of string
        | HangarPlanesCapacityError of string
        | HangarNotFoundError of string
        | PlaneNotFoundError of string
        | InvalidInputError of string

    type Plane = { Name: string; Missiles: int list }

    type Hangar = Plane list

    type SystemState =
        { Hangars: Hangar array
          GlobalMissileSet: Set<int> }

    type SystemMessage =
        | GetState of AsyncReplyChannel<SystemState>
        | UpdateHangar of int * Hangar

    let systemAgentMutable =
        MailboxProcessor<SystemMessage>.Start(fun inbox ->
            // Mutable state - Acceptable due to this being a `MailboxProcessor`, which only responds to one message at a time, ordered on time of arrival
            let initialState =
                { Hangars = Array.init 5 (fun _ -> [])
                  GlobalMissileSet = Set.empty }

            let mutable globalMissileSet = Set.empty

            let rec loop (state: SystemState) =
                async {
                    let! msg = inbox.Receive()

                    match msg with
                    | GetState reply -> reply.Reply state
                    | UpdateHangar(idx, hangar) ->
                        state.Hangars.[idx] <- hangar
                        // Recompute GlobalMissileSet
                        globalMissileSet <-
                            state.Hangars
                            |> Array.collect (fun h -> h |> List.collect (fun p -> p.Missiles) |> List.toArray)
                            |> Set.ofArray

                    return! loop state
                }

            loop initialState)

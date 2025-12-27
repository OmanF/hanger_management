namespace HangerManager

[<AutoOpen>]
module Helpers =
    let isUnique (checkedSet: Set<'a>) (currentSet: Set<'a>) : bool =
        Set.intersect checkedSet currentSet |> Set.isEmpty

    let areUniquePerPlane (missiles: int<mID> list) : Result<int<mID> list, Errors> =
        let missileSet = Set.ofList missiles

        match List.length missiles = Set.count missileSet with
        | true -> Ok missiles
        | false -> PlaneMissilesUniquenessError "Missiles are not unique per plane." |> Error

    let areUniqueGlobally (missiles: int<mID> list) (state: SystemState) : Result<int<mID> list, Errors> =
        let missileSet = Set.ofList missiles

        match isUnique missileSet state.GlobalMissileSet with
        | true -> Ok missiles
        | false ->
            PlaneMissilesUniquenessError "Some missiles are already assigned to other planes."
            |> Error

    let stateAgent =
        MailboxProcessor<SystemMessage>.Start(fun inbox ->
            let initialState =
                { Hangars = Array.init 5 (fun _ -> [||])
                  GlobalMissileSet = Set.empty }

            let rec loop state =
                async {
                    let! msg = inbox.Receive()

                    match msg with
                    | GetState reply -> reply.Reply state
                    | UpdateHangar((idx, hangar), reply) ->
                        match Array.tryItem idx state.Hangars with
                        | None ->
                            reply.Reply(
                                $$$"""Hangar index %%%i{{{idx}}} is out of bounds."""
                                |> HangarNotFoundError
                                |> Error
                            )
                        | Some _ ->
                            let newHangars =
                                state.Hangars |> Array.mapi (fun i h -> if i = idx then hangar else h)

                            let newState = { state with Hangars = newHangars }
                            reply.Reply(Ok newState)

                    return! loop state
                }

            loop initialState)

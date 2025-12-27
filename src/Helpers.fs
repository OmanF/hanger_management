namespace HangerManager

[<AutoOpen>]
module Helpers =
    let isUnique (checkedSet: Set<'a>) (currentSet: Set<'a>) : bool =
        Set.isEmpty (Set.intersect checkedSet currentSet)

    let stateAgent =
        MailboxProcessor<SystemMessage>.Start(fun inbox ->
            let initialState =
                { Hangars = Array.init 5 (fun _ -> [||])
                  GlobalMissileSet = Set.empty }

            let rec loop (state: SystemState) =
                async {
                    let! msg = inbox.Receive()

                    match msg with
                    | GetState reply -> reply.Reply state
                    | UpdateHangar((idx, hangar), reply) ->
                        match Array.tryItem idx state.Hangars with
                        | None -> reply.Reply(Error(HangarNotFoundError $"Hangar index {idx} is out of bounds."))
                        | Some _ ->
                            let newHangars =
                                state.Hangars |> Array.mapi (fun i h -> if i = idx then hangar else h)

                            let newState = { state with Hangars = newHangars }
                            reply.Reply(Ok newState)
                }

            loop initialState)

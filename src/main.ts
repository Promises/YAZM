import {Timer, Unit} from "w3ts";
import {addScriptHook, W3TS_HOOK} from "w3ts/hooks";
import {Yasm} from "./yasm";


addScriptHook(W3TS_HOOK.MAIN_AFTER, () => {
    new Timer().start(1, false, () => {
        xpcall(() => {
            Yasm();
        }, (err) => {
            print(err)
        });
    })
});

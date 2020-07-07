import {Players} from "w3ts/globals/index";
import {Trigger, MapPlayer} from "w3ts/index";

const Keys = [
    OSKEY_W,
    OSKEY_A,
    OSKEY_S,
    OSKEY_D,
]

enum Metakeys {
    NONE,
    SHIFT
}

export class KeyInput {
    inputTrigger: Trigger;

    constructor() {
        this.inputTrigger = new Trigger();
        this.setupKeys();
    }

    setupKeys() {
        Players.forEach((player) => {
            for (let metakey in Metakeys) {
                if(typeof metakey === "number"){
                    for (let key of Keys) {
                        this.inputTrigger.registerPlayerKeyEvent(player, key, metakey,true);
                        this.inputTrigger.registerPlayerKeyEvent(player, key, metakey,false);
                    }
                }

            }
        });
        this.inputTrigger.addAction(() => this.keyEvent());

    }

    private keyEvent() {
        const keyPressed: oskeytype = BlzGetTriggerPlayerKey();
        const isKeyDown: boolean = BlzGetTriggerPlayerIsKeyDown();
        const player: MapPlayer = MapPlayer.fromEvent();
        const metaKeyPressed: number = BlzGetTriggerPlayerMetaKey()
        print(metaKeyPressed);
    }
}

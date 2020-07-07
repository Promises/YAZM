import {Trigger, Timer} from "w3ts/index";
import {Players, ZPlayer} from "../ZPlayer";

const osKeys = [
    OSKEY_W,
    OSKEY_A,
    OSKEY_S,
    OSKEY_D,
]

enum Key {
    W,
    A,
    S,
    D,
    SHIFT,
}

enum Metakeys {
    NONE,
    SHIFT
}

export class KeyInput {
    inputTrigger: Trigger;
    keysDown: boolean[][] = [];
    static moveDistance = 10.0;

    constructor() {
        this.inputTrigger = new Trigger();
        this.setupKeys();
    }

    setupKeys() {
        for (let player of Players) {
            print(player.name)
            this.keysDown[player.id] = [];
            for (let key of osKeys) {
                this.keysDown[player.id][osKeys.indexOf(key)] = false;
                for (let metakey in Metakeys) {
                    if (typeof metakey === "number") {
                        this.inputTrigger.registerPlayerKeyEvent(player, key, metakey, true);
                        this.inputTrigger.registerPlayerKeyEvent(player, key, metakey, false);
                    }
                }

            }
        }
        this.inputTrigger.addAction(() => this.keyEvent());
        new Timer().start( 0.03, true, () => this.movePlayerUnit());
    }

    private keyEvent() {
        const keyPressed: oskeytype = BlzGetTriggerPlayerKey();
        const isKeyDown: boolean = BlzGetTriggerPlayerIsKeyDown();
        const player: ZPlayer = ZPlayer.fromEvent();
        const metaKeyPressed: number = BlzGetTriggerPlayerMetaKey()
        this.keysDown[player.id][osKeys.indexOf(keyPressed)] = isKeyDown;
        this.keysDown[player.id][Key.SHIFT] = metaKeyPressed === 1;
    }

    private movePlayerUnit() {
        // const player: ZPlayer = ZPlayer.fromEvent();
        for (let player of Players){
            const keys = this.keysDown[player.id];
            if(!keys[Key.W] && !keys[Key.A] && !keys[Key.S] && !keys[Key.D]) {
                continue;
            }
            let angle: number;
            let angleDeg: number;
            let dx: number = 0;
            let dy: number = 0;

            if(keys[Key.W]) {
                dy++;
            }
            if(keys[Key.S]) {
                dy--;
            }
            if(keys[Key.A]) {
                dx++;
            }
            if(keys[Key.D]) {
                dx--;
            }

            angle = Atan2(dy, dx) + player.avatar.facing**bj_DEGTORAD;
            print(player.avatar.facing)
            print(angle)
            dx = player.avatar.x + KeyInput.moveDistance*Cos(angle)
            dy = player.avatar.y + KeyInput.moveDistance*Sin(angle)
            player.avatar.x = dx;
            player.avatar.y = dy;
        }

    }
}

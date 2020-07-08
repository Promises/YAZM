import {Trigger, Timer} from "w3ts/index";
import {Players, ZPlayer} from "../ZPlayer";

const osKeys = [
    OSKEY_W,
    OSKEY_A,
    OSKEY_S,
    OSKEY_D,
]

export enum MouseKey {
    LEFT,
    RIGHT
}

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
        this.fixLeftClick()
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
        new Timer().start(0.03, true, () => this.movePlayerUnit());
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
        for (let player of Players) {
            const keys = this.keysDown[player.id];
            if (!keys[Key.W] && !keys[Key.A] && !keys[Key.S] && !keys[Key.D]) {
                ResetUnitAnimation(player.avatar.handle);
                continue;
            }
            let moveSpeed = KeyInput.moveDistance;
            if (keys[Key.SHIFT]) {
                moveSpeed *= 1.75;
                SetUnitTimeScalePercent( player.avatar.handle, 175.00 )
            } else {
                SetUnitTimeScalePercent( player.avatar.handle, 100.00 )
            }
            let angle: number;
            let dx: number = 0;
            let dy: number = 0;

            if (keys[Key.W]) {
                dy++;
            }
            if (keys[Key.S]) {
                dy--;
            }
            if (keys[Key.A]) {
                dx--;
            }
            if (keys[Key.D]) {
                dx++;
            }

            angle = Atan2(dy, dx)
            player.playWalkAnim();
            dx = player.avatar.x + moveSpeed * Cos(angle)
            dy = player.avatar.y + moveSpeed * Sin(angle)

            if (!player.leftMouse) {
                player.setUnitFace(dx, dy);
            }

            if (!IsTerrainPathable(player.avatar.x + (moveSpeed * 5) * Cos(angle), player.avatar.y + (moveSpeed * 5) * Sin(angle), PATHING_TYPE_WALKABILITY)) {
                player.avatar.x = dx;
                player.avatar.y = dy;
            }

        }

    }

    private fixLeftClick() {
        CreateMultiboardBJ(1, 60, "")
        MultiboardSetItemWidthBJ(GetLastCreatedMultiboard(), 1, 1, 110)
        MultiboardMinimizeBJ(false, GetLastCreatedMultiboard())
        BlzFrameSetAbsPoint(BlzGetFrameByName("Multiboard", 0), FRAMEPOINT_TOPRIGHT, 0.81, 0.64)
        BlzFrameSetAlpha(BlzGetFrameByName("Multiboard", 0), 0)
    }
}

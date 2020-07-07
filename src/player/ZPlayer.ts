import {MapPlayer, Timer, Unit} from "w3ts";
import {KeyInput} from "./input/keyinput";


// @ts-ignore
export class ZPlayer extends MapPlayer {
    avatar: Unit;

    constructor(index: number) {
        super(index);
        print("Hello world")
        new Timer().start(0.5, false, () => {
            this.avatar = new Unit(this, FourCC("hfoo"), 0, 0, 270)
            this.avatar.name = this.name;
            new Timer().start(0.5, false, () => {
                SetCameraTargetControllerNoZForPlayer(this.handle, this.avatar.handle, 0, 0, false);
                EnableSelect(false, true);
                new Timer().start(0.1, false, () => {
                    SelectUnitForPlayerSingle(this.avatar.handle, this.handle)

                });
            });
        });

    }


    public static fromHandle(handle: player): ZPlayer {
        return Players[GetPlayerId(handle)];
    }

    public static fromEnum() {
        return ZPlayer.fromHandle(GetEnumPlayer());
    }

    public static fromEvent() {
        return ZPlayer.fromHandle(GetTriggerPlayer());
    }

    public static fromFilter() {
        return ZPlayer.fromHandle(GetFilterPlayer());
    }

    public static fromIndex(index: number) {
        return this.fromHandle(Player(index));
    }

    public static fromLocal() {
        return this.fromHandle(GetLocalPlayer());
    }
}


export const Players: ZPlayer[] = [];

export function SetupPlayers() {
    for (let i: number = 0; i < bj_MAX_PLAYER_SLOTS; i++) {
        if (GetPlayerSlotState(Player(i)) === PLAYER_SLOT_STATE_PLAYING) {
            if (GetPlayerController(Player(i)) === MAP_CONTROL_USER) {
                Players[i] = new ZPlayer(i);
            }
        }
    }
}





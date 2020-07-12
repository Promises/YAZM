import {MapPlayer, Timer, Unit, Trigger} from "w3ts";
import { Missile } from "wc3ts-missile";


// @ts-ignore
export class ZPlayer extends MapPlayer {
    avatar: Unit;
    private mouseMoveTrigger: Trigger;
    private mousePressDownTrigger: Trigger;
    private mouseReleaseTrigger: Trigger;
    walkTick: number = 0;
    mouseX: number = 0;
    mouseY: number = 0;
    pressedButtons: boolean[];
    leftMouse: boolean = false;

    constructor(index: number) {
        super(index);
        print("Hello world")

        this.pressedButtons = [];
        new Timer().start(0.1, false, () => {
            this.avatar = new Unit(this, FourCC("hfoo"), 0, 0, 270)
            this.avatar.name = this.name;
            new Timer().start(0.1, false, () => {
                SetCameraTargetControllerNoZForPlayer(this.handle, this.avatar.handle, 0, 150, false);
                EnableSelect(false, true);
                SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK, 300, 1);
                new Timer().start(0.1, false, () => {
                    SelectUnitForPlayerSingle(this.avatar.handle, this.handle)
                    this.mouseMoveTrigger = new Trigger();
                    this.mouseMoveTrigger.registerPlayerMouseEvent(this, bj_MOUSEEVENTTYPE_MOVE)
                    this.mouseMoveTrigger.addAction(() => this.mouseMoved())
                    this.mousePressDownTrigger = new Trigger();
                    this.mouseReleaseTrigger = new Trigger();
                    this.mousePressDownTrigger.registerPlayerMouseEvent(this, bj_MOUSEEVENTTYPE_DOWN)
                    this.mouseReleaseTrigger.registerPlayerMouseEvent(this, bj_MOUSEEVENTTYPE_UP)
                    this.mousePressDownTrigger.addAction(() => this.mousePressed(true))
                    this.mouseReleaseTrigger.addAction(() => this.mousePressed(false))

                });
            });
        });

    }


    private mouseMoved() {
        this.mouseX = BlzGetTriggerPlayerMouseX();
        this.mouseY = BlzGetTriggerPlayerMouseY();
        if (this.leftMouse) {
            this.setUnitFace(this.mouseX, this.mouseY);
        }
    }

    public playWalkAnim() {
        if (this.walkTick === 0) {
            SetUnitAnimationByIndex(this.avatar.handle, 6)

        }
        if (this.walkTick === 5) {
            this.walkTick = -1;
        }
        this.walkTick++;
    }

    private mousePressed(pressed: boolean) {
        const button = BlzGetTriggerPlayerMouseButton();
        if (button == MOUSE_BUTTON_TYPE_LEFT) {
            this.leftMouse = pressed;
                new Missile(this.avatar, this.mouseX, this.mouseY);

        }
        this.mouseMoved();

        // if (button == MOUSE_BUTTON_TYPE_LEFT) {
        //     this.pressedButtons[MouseKey.LEFT] = pressed;
        // }
        // if (button == MOUSE_BUTTON_TYPE_RIGHT) {
        //     this.pressedButtons[MouseKey.RIGHT] = pressed;
        // }
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

    public setUnitFace(x: number, y: number) {
        SetUnitFacingTimed(this.avatar.handle, bj_RADTODEG * Atan2(y - this.avatar.y, x - this.avatar.x), 0)
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





import {ZPlayer} from "../../player/ZPlayer";
import {Unit} from "w3ts";
import {TimedEventQueue} from 'wc3ts-eventqueue';

export abstract class Weapon {
    private player: ZPlayer;
    abstract speed: number;
    active: boolean = false;

    constructor(player: ZPlayer) {
        this.player = player;
    }

    setActive() {
        this.active = true;
    }

    public action() {
        if(this.active && this.player.leftMouse) {
            this.fire()
        }
        TimedEventQueue.CreateEvent(() => this.action(), this.speed);
    }

    abstract fire(): void;

    get avatar(): Unit {
        return this.player.avatar;
    }

    getTargetLocation(): { x: number, y: number } {
        let facing = (this.avatar.facing) * bj_DEGTORAD;
        return {
            x: this.avatar.x + 10 * Cos(facing),
            y: this.avatar.y + 10 * Sin(facing)
        };
    }

    start() {
        TimedEventQueue.CreateEvent(() => this.action(), this.speed);
    }
}

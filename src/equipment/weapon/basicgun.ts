import {Weapon} from "./weapon";
import {Missile} from "wc3ts-missile";

export class BasicGun extends Weapon {

    fire(): void {
        let target = this.getTargetLocation();
        new Missile(this.avatar, target.x, target.y, {effectModel: 'Abilities\\Weapons\\RocketMissile\\RocketMissile.mdl', scale: 0.2});
        return;
    }

    speed: number = 31;
}

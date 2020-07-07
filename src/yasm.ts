import {SetupPlayers} from "./player/ZPlayer";
import {KeyInput} from "./player/input/keyinput";
import {Timer} from "w3ts";

const BUILD_DATE = compiletime(() => new Date().toUTCString());
const TS_VERSION = compiletime(() => require("typescript").version);
const TSTL_VERSION = compiletime(() => require("typescript-to-lua").version);
export function Yasm() {
    print(`Build: ${BUILD_DATE}`);
    print(`Typescript: v${TS_VERSION}`);
    print(`Transpiler: v${TSTL_VERSION}`);
    print(" ");
    print("Welcome to TypeScript!");
    SetupPlayers();

    new Timer().start(2, false, () => new KeyInput());
}

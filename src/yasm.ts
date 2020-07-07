import {SetupPlayers, ZPlayer} from "./player/ZPlayer";
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
    // disable frame things
    BlzHideOriginFrames(true);
    // BlzFrameSetAllPoints(worldFrame, gameUiFrame);

    // show menu items and resources
    BlzFrameSetVisible(BlzGetFrameByName("UpperButtonBarFrame", 0), true); //Show Quests, Menu, Allies, Log
    BlzFrameSetVisible(BlzGetFrameByName("ResourceBarFrame", 0), true); //Show Gold, Lumber, food and Upkeep; also enables /fps /ping /apm
    BlzFrameSetVisible(BlzGetFrameByName("ConsoleUIBackdrop", 0), false);

    new Timer().start(2, false, () => new KeyInput());
}



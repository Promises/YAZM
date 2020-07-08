const DUMMY_RAW_CODE: number = FourCC('dumi');
const PERIOD: number = 1.32;
const COLLISION_SIZE: number = 128;
const RECYCLE_TIME: number = 2;
const LOC: location = Location(0, 0);
const RECT: rect = Rect(0, 0, 0, 0);
const tabl: hashtable = InitHashtable();

interface MissileEvents {
    onHit: (hit: unit) => boolean;
    onTerrain: () => boolean;
    onPeriod: () => boolean;
    onFinish: () => boolean;
    onRemove: () => boolean;
    onDestructable: (dest: destructable) => boolean;
}

function GetLocZ(x: number, y: number): number {
    MoveLocation(LOC, x, y)
    return GetLocationZ(LOC)
}



use duktape, duktape-link
import duk/tape

import io/FileReader

nativePrimeCheck: func (ctx: DukContext) -> Int {
    val := ctx requireInt(0)
    lim := ctx requireInt(1)
    i := 2
    while (i <= lim) {
        if (val % i == 0) {
            ctx pushFalse()
            return 1
        }
        i += 1
    }

    ctx pushTrue()
    1
}

/*
 * Ported from http://duktape.org/guide.html
 */
main: func {
    ctx := DukContext createHeapDefault()
    if (!ctx) {
        "Failed to create a Duktape heap." println()
        exit(1)
    }

    ctx pushGlobalObject()
    ctx pushCFunction(nativePrimeCheck, 2)
    ctx putPropString(-2, "primeCheckNative")

    if (ctx pevalFile("prime.js") != 0) {
        "Error: %s" printfln(ctx safeToString(-1))
    }
    ctx pop()

    ctx getPropString(-1, "primeTest")
    if (ctx pcall(0) != 0) {
        "Error: %s" printfln(ctx safeToString(-1))
    }
    ctx pop()

    ctx destroyHeap()
}


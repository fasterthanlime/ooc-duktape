
use duktape
import duk/tape

import io/FileReader

/*
 * Ported from http://duktape.org/guide.html
 */
main: func {
    ctx := DukContext createHeapDefault()
    if (!ctx) {
        "Failed to create a Duktape heap." println()
        exit(1)
    }

    if (ctx pevalFile("process.js") != 0) {
        "Error: %s" printfln(ctx safeToString(-1))
    }
    ctx pop()

    reader := FileReader new(stdin)
    while (reader hasNext?()) {
        line := reader readLine()
        ctx pushGlobalObject()
        ctx getPropString(-1, "processLine")
        ctx pushString(line toCString())
        if (ctx pcall(1) != 0) {
            "Error: %s" printfln(ctx safeToString(-1))
        } else {
            "%s" printfln(ctx safeToString(-1))
        }
        ctx pop() // pop result/error
    }

    ctx destroyHeap()
}


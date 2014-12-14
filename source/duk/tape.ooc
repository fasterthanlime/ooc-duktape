include ./duktape

DukInt: cover from duk_int_t extends Int

duk_gc_malloc_shim: func (udata: Pointer, size: SizeT) {
    gc_malloc(size)
}

duk_gc_realloc_shim: func (udata: Pointer, ptr: Pointer, size: SizeT) {
    gc_realloc(ptr, size)
}

duk_gc_free_shim: func (udata: Pointer, ptr: Pointer) {
    gc_free(ptr)
}

DukContext: cover from duk_context* {

    createHeapDefault: extern(duk_create_heap_default) static func -> This
    createHeap: extern(duk_create_heap) static func(
        alloc_func: Pointer,
        realloc_func: Pointer,
        free_func: Pointer,
        alloc_udata: Pointer,
        fatal_handler: Pointer) -> This

    createHeapBoehmGC: static func -> This {
        This createHeap(
            duk_gc_malloc_shim,
            duk_gc_realloc_shim,
            duk_gc_free_shim,
            null,
            null)
    }

    destroyHeap: extern(duk_destroy_heap) func

    /** @return 0 on success */
    pevalFile: extern(duk_peval_file) func (CString) -> Int
    pevalString: extern(duk_peval_string) func (CString) -> Int

    /** @return 0 on success */
    pcall: extern(duk_pcall) func (nargs: Int) -> Int

    requireInt: extern(duk_require_int) func (index: Int) -> DukInt
    requirePointer: extern(duk_require_pointer) func (index: Int) -> Pointer
    requireNumber: extern(duk_require_number) func (index: Int) -> Double
    requireString: extern(duk_require_string) func (index: Int) -> CString
    requireBoolean: extern(duk_require_boolean) func (index: Int) -> Bool
    requireObjectCoercible: extern(duk_require_object_coercible) func (index: Int)

    pushGlobalObject: extern(duk_push_global_object) func
    pushObject: extern(duk_push_object) func -> Int
    pushString: extern(duk_push_string) func (val: CString)
    pushBoolean: extern(duk_push_boolean) func (val: Bool)
    pushCFunction: extern(duk_push_c_function) func (p: Pointer, nargs: Int)
    pushFalse: extern(duk_push_false) func
    pushTrue: extern(duk_push_true) func
    pushPointer: extern(duk_push_pointer) func (p: Pointer)
    pushInt: extern(duk_push_int) func (val: Int)
    pushNumber: extern(duk_push_number) func (val: Double)
    pushThis: extern(duk_push_this) func

    setPrototype: extern(duk_set_prototype) func (index: Int)

    putGlobalString: extern(duk_put_global_string) func (name: CString)
    getGlobalString: extern(duk_get_global_string) func (name: CString)

    putPropString: extern(duk_put_prop_string) func (index: Int, name: CString)
    getPropString: extern(duk_get_prop_string) func (index: Int, name: CString)

    isUndefined: extern(duk_is_undefined) func (index: Int) -> Bool

    pop: extern(duk_pop) func
    pop2: extern(duk_pop_2) func
    pop3: extern(duk_pop_3) func
    popn: extern(duk_pop_n) func (howmany: Int)
    dup: extern(duk_dup) func (index: Int)

    safeToString: extern(duk_safe_to_string) func (index: Int) -> CString

}


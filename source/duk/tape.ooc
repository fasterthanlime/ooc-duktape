include ./duktape | (DUK_OPT_NO_VOLUNTARY_GC)

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

DukException: class extends Exception {
    init: func (cause, trace: String) { 
        msg := "[Duk]: #{cause}\n======== Trace ========\n#{trace}\n======== Trace end ========="
        super(msg)
    }
}

DUK_VARARGS: extern Int

PropFlags: enum from Int {
    /// set writable (effective if DUK_DEFPROP_HAVE_WRITABLE set)
    WRITABLE: extern(DUK_DEFPROP_WRITABLE),
    /// set enumerable (effective if DUK_DEFPROP_HAVE_ENUMERABLE set)
    ENUMERABLE: extern(DUK_DEFPROP_ENUMERABLE),
    /// set configurable (effective if DUK_DEFPROP_HAVE_CONFIGURABLE set)
    CONFIGURABLE: extern(DUK_DEFPROP_CONFIGURABLE),
    /// set/clear writable 
    HAVE_WRITABLE: extern(DUK_DEFPROP_HAVE_WRITABLE),
    /// set/clear enumerable
    HAVE_ENUMERABLE: extern(DUK_DEFPROP_HAVE_ENUMERABLE),
    /// set/clear configurable
    HAVE_CONFIGURABLE: extern(DUK_DEFPROP_HAVE_CONFIGURABLE),
    /// set value (given on value stack)
    HAVE_VALUE: extern(DUK_DEFPROP_HAVE_VALUE),
    /// set getter (given on value stack)
    HAVE_GETTER: extern(DUK_DEFPROP_HAVE_GETTER),
    /// set setter (given on value stack)
    HAVE_SETTER: extern(DUK_DEFPROP_HAVE_SETTER),
    /// force change if possible, may still fail for e.g. virtual properties
    FORCE: extern(DUK_DEFPROP_FORCE)
}

DukContext: cover from duk_context* {

    raise!: func {
        exception!() throw()
    }

    exception!: func -> DukException {
        getPropString(-1, "stack")
        trace := safeToString(-1) as String
        pop()
        cause := safeToString(-1) as String
        DukException new(cause, trace)
    }

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
    requireBuffer: extern(duk_require_buffer) func (index: Int, sizeout: SizeT*) -> UInt8*

    pushGlobalObject: extern(duk_push_global_object) func
    pushObject: extern(duk_push_object) func -> Int
    pushArray: extern(duk_push_array) func -> Int
    pushString: extern(duk_push_string) func (val: CString)
    pushBoolean: extern(duk_push_boolean) func (val: Bool)
    pushCFunction: extern(duk_push_c_function) func (p: Pointer, nargs: Int)
    pushFalse: extern(duk_push_false) func
    pushTrue: extern(duk_push_true) func
    pushPointer: extern(duk_push_pointer) func (p: Pointer)
    pushInt: extern(duk_push_int) func (val: Int)
    pushNumber: extern(duk_push_number) func (val: Double)
    pushThis: extern(duk_push_this) func
    pushNull: extern(duk_push_null) func
    pushBuffer: extern(duk_push_buffer) func (size: SizeT, dynamic: Bool) -> UInt8*
    pushFixedBuffer: extern(duk_push_fixed_buffer) func (size: SizeT) -> UInt8*
    pushDynamicBuffer: extern(duk_push_dynamic_buffer) func (size: SizeT) -> UInt8*

    setPrototype: extern(duk_set_prototype) func (index: Int)

    putGlobalString: extern(duk_put_global_string) func (name: CString)
    getGlobalString: extern(duk_get_global_string) func (name: CString)

    putPropString: extern(duk_put_prop_string) func (index: Int, name: CString)
    getPropString: extern(duk_get_prop_string) func (index: Int, name: CString)
    delPropString: extern(duk_del_prop_string) func (index: Int, name: CString)

    putPropIndex: extern(duk_put_prop_index) func (objIndex: Int, arrIndex: Int)
    getPropIndex: extern(duk_get_prop_index) func (objIndex: Int, arrIndex: Int)
    delPropIndex: extern(duk_del_prop_index) func (objIndex: Int, arrIndex: Int)

    defProp: extern(duk_def_prop) func (objIndex: Int, flags: Int)
    delProp: extern(duk_del_prop) func (objIndex: Int)

    isUndefined: extern(duk_is_undefined) func (index: Int) -> Bool
    isNull: extern(duk_is_null) func (index: Int) -> Bool
    isNullOrUndefined: extern(duk_is_null_or_undefined) func (index: Int) -> Bool
    isNumber: extern(duk_is_number) func (index: Int) -> Bool
    isString: extern(duk_is_string) func (index: Int) -> Bool
    isBoolean: extern(duk_is_boolean) func (index: Int) -> Bool
    isBuffer: extern(duk_is_buffer) func (index: Int) -> Bool

    pop: extern(duk_pop) func
    pop2: extern(duk_pop_2) func
    pop3: extern(duk_pop_3) func
    popn: extern(duk_pop_n) func (howmany: Int)
    dup: extern(duk_dup) func (index: Int)

    getTop: extern(duk_get_top) func -> Int

    safeToString: extern(duk_safe_to_string) func (index: Int) -> CString

    _error: extern(duk_error) func (errcode: Int, fmt: CString, ...)
    throwError: func (msg: String) {
        _error(0, c"%s", msg toCString())
    }

    _pushErrorObject: extern(duk_push_error_object) func (errcode: Int, fmt: CString, ...)
    pushError: func (msg: String) {
        _pushErrorObject(0, c"%s", msg toCString())
    }

}

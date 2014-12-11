include ./duktape

DukInt: cover from duk_int_t extends Int

DukContext: cover from duk_context* {

    createHeapDefault: extern(duk_create_heap_default) static func -> This
    destroyHeap: extern(duk_destroy_heap) func

    /** @return 0 on success */
    pevalFile: extern(duk_peval_file) func (CString) -> Int

    /** @return 0 on success */
    pcall: extern(duk_pcall) func (nargs: Int) -> Int

    requireInt: extern(duk_require_int) func (index: Int) -> DukInt

    pushGlobalObject: extern(duk_push_global_object) func
    pushString: extern(duk_push_string) func (val: CString)
    pushCFunction: extern(duk_push_c_function) func (p: Pointer, nargs: Int)
    pushFalse: extern(duk_push_false) func
    pushTrue: extern(duk_push_true) func

    putPropString: extern(duk_put_prop_string) func (index: Int, name: CString)
    getPropString: extern(duk_get_prop_string) func (index: Int, name: CString)

    pop: extern(duk_pop) func

    safeToString: extern(duk_safe_to_string) func (index: Int) -> CString

}


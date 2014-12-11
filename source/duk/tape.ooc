include ./duktape

DukContext: cover from duk_context* {

    createHeapDefault: extern(duk_create_heap_default) static func -> This
    destroyHeap: extern(duk_destroy_heap) func

    /** @return 0 on success */
    pevalFile: extern(duk_peval_file) func (CString) -> Int

    /** @return 0 on success */
    pcall: extern(duk_pcall) func (nargs: Int) -> Int

    pushGlobalObject: extern(duk_push_global_object) func
    pushString: extern(duk_push_string) func (val: CString)

    getPropString: extern(duk_get_prop_string) func (index: Int, name: CString) -> CString

    pop: extern(duk_pop) func

    safeToString: extern(duk_safe_to_string) func (index: Int) -> CString

}


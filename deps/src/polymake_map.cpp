#include "polymake_includes.h"

#include "polymake_tools.h"

#include "polymake_functions.h"

#include "polymake_type_modules.h"


void polymake_module_add_map(jlcxx::Module& polymake)
{

    auto type = polymake
        .add_type<jlcxx::Parametric<jlcxx::TypeVar<1>, jlcxx::TypeVar<2>>>(
            "Map", jlcxx::julia_type("AbstractDict", "Base" ));

        type.apply<pm::Map<std::string, std::string>>([&polymake](auto wrapped) {

            typedef typename decltype(wrapped)::type WrappedT;
            typedef typename decltype(wrapped)::type::key_type keyT;
            typedef typename decltype(wrapped)::type::mapped_type valT;

            wrapped.method("_getindex", [](WrappedT& M, keyT& key) {
                return M[key];
            });

            wrapped.method("_setindex!", [](WrappedT& M, valT& val, keyT& key) {
                M[key] = val;
            });

            wrapped.method("show_small_obj", [](WrappedT& S) {
                return show_small_object<WrappedT>(S);
            });
        });

    polymake.method("to_map_string_string", [](pm::perl::PropertyValue pv) {
        return to_SmallObject<pm::Map<std::string, std::string>>(pv);
    });

}

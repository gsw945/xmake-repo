package("zmqpb")
    set_homepage("https://github.com/SFGrenade/ZmqPb/")
    set_description("A helper to use zeromq and protobuf together")
    set_license("MPL-2.0")

    set_urls("https://github.com/SFGrenade/ZmqPb/archive/refs/tags/v$(version).tar.gz",
             "https://github.com/SFGrenade/ZmqPb.git")
    add_versions("0.1", "4a34ec92faa381306356e84e2a2000093d8f76cfa037db1f4cd0adb0205faebb")
    add_versions("0.2", "5dfa4d4cebb10cb7ae03943e18e8d48c8ff215e80371f24c5ade212be7f20721")
    add_versions("0.3", "343c57c9f72facca47082422a259ec8c531f5c6e332a3828835080c4a96b9064")

    add_deps("cppzmq")
    add_deps("protobuf-cpp")

    on_load("windows", "macosx", "linux", function (package)
        if not package:gitref() and package:version():lt("0.3") then
            package:add("deps", "fmt")
        end
    end)

    on_install("windows", "macosx", "linux", function (package)
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        if package:gitref() or package:version():ge("0.3") then
            assert(package:check_cxxsnippets({test = [[
                void test() {
                    ZmqPb::ReqRep network( "tcp://127.0.0.1:13337", false );
                    network.run();
                }
            ]]}, {configs = {languages = "c++14"}, includes = "zmqPb/reqRep.hpp"}))
        else
            assert(package:check_cxxsnippets({test = [[
                void test() {
                    ZmqPb::ReqRep network( "tcp://127.0.0.1", 13337, false );
                    network.run();
                }
            ]]}, {configs = {languages = "c++14"}, includes = "zmqPb/reqRep.hpp"}))
        end
    end)

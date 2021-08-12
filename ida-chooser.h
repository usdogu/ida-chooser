﻿// ida-chooser.h: Standart sistem ekleme dosyaları için ekleme dosyası,
// veya projeye özgü ekleme dosyaları.

#pragma once

#include <fstream>
#include <iostream>
#include <Windows.h>
#include <string>


// TODO: Burada programınızın gerektirdiği ek üst bilgilere başvurun.
auto get_arch(const char* exe) -> int;
auto get_reg() -> void;
auto is_first_run()-> bool;
auto trim(const std::string& s)->std::string;
auto set_ida_path(std::string& path) -> void;
auto get_ida_path()-> std::string;
bool ends_with(std::string const& src, std::string const& search);
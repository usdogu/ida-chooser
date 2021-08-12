# CMakeList.txt: ida-chooser için CMake projesi, kaynağı ekleyin ve tanımlayın
# projeye özgü mantık burada bulunur.
#
cmake_minimum_required (VERSION 3.8)

project ("ida-chooser")

# Kaynağı bu projenin yürütülebilir dosyasına ekleyin.
add_executable (ida-chooser "ida-chooser.cpp" "ida-chooser.h"  "utilities.cpp" "string-manupilation.cpp")

# TODO: Gerekirse testleri ve yükleme hedeflerini ekleyin.

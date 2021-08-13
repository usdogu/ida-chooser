#include "ida-chooser.h"

using namespace std;

auto is_first_run() -> bool
{
	HKEY key = nullptr;
	const LONG result = RegOpenKeyExA(HKEY_CURRENT_USER, "Software\\IDAChooser", NULL, KEY_READ, &key);
	RegCloseKey(key);
	return result == ERROR_FILE_NOT_FOUND;
}



auto set_ida_path(std::string& path) -> void
{

	if (ends_with(path, "\\") || ends_with(path, "/"))
	{
		path.pop_back();
	}
	HKEY key = nullptr;
	DWORD position;
	const int result = RegCreateKeyExA(HKEY_CURRENT_USER, "Software\\IDAChooser", NULL, nullptr, NULL, KEY_ALL_ACCESS, nullptr, &key, &position);
	if (!result)
	{
		RegSetValueExA(key, "Path", NULL, REG_SZ, (BYTE*)path.c_str(), path.size());
	}

	RegCloseKey(key);
}

auto get_arch(const char* exe) -> int
{
	ifstream file;
	file.open(exe, ios::binary | ios::in);

	file.seekg(0x3c, ios::beg);
	uint32_t offset = 0;
	file.read(reinterpret_cast<char*>(&offset), sizeof(offset));

	file.seekg(offset + 4, ios::beg);
	uint16_t machine = 0;
	file.read(reinterpret_cast<char*>(&machine), sizeof(machine));

	file.close();
	return machine;
}

auto get_ida_path() -> string
{
	HKEY key = nullptr;
	RegOpenKeyExA(HKEY_CURRENT_USER, "Software\\IDAChooser", NULL, KEY_READ, &key);
	char data[256]{};
	DWORD data_size = sizeof(data);
	RegQueryValueExA(key, "Path", nullptr, nullptr, reinterpret_cast<LPBYTE>(data), &data_size);

	RegCloseKey(key);
	return string(data);
}



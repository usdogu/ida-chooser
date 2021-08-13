#include "ida-chooser.h"

using namespace std;

bool ends_with(std::string const& src, std::string const& search) {
	const auto len = search.length();
	const auto pos = src.length() - len;
	if (pos < 0)
		return false;
	auto pos_a = &src[pos];
	auto pos_b = &search[0];
	while (*pos_a)
		if (*pos_a++ != *pos_b++)
			return false;
	return true;
}


auto trim(const std::string& s) -> std::string
{
	auto start = s.begin();
	while (start != s.end() && std::isspace(*start)) {
		start++;
	}

	auto end = s.end();
	do {
		end--;
	} while (std::distance(start, end) > 0 && std::isspace(*end));

	return std::string(start, end + 1);
}